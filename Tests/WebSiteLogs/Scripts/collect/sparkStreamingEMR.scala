//Import required libraries
import org.apache.spark.SparkContext
import org.apache.spark.sorate.StorageLevel
import org.apache.spark.streaming.Seconds
import org.apache.spark.streaming.StreamingContext
import org.apache.spark.streaming.StreamingContext.toPairDstreamFunuctions
import org.apache.spark.streaming.kinesis.KinesisUtils
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain
import com.amazonaws.services.kinesis.AmazonKinesisClient
import com.amazonaws.services.kinesis.clientlibrary.lib.worker._
import java.util.Date
import org.apache.hadoop.io.compress._

object sparkStreamingEMR {

  //Set up the variables as needed
  val region = "us-east-1" //?insert region here
  val bucketName = "my_bucket" //?insert bucket name here

  val streamName = "AccessLogStream"
  val endpointUrl = s"https://kinesis.$region.amazonaws.com"
  val outputDir = s"s3://$bucketName//access-log-raw"
  val outputInterval = Seconds(60)

  def main(args: Array[String]): Unit = {

    //Reconfigure spark-shell
    val sparkConf = sc.getConf //This is only for spark-shell when is predefined sc
    sparkConf.setAppName("S3Writer")
    sparkConf.remove("spark.driver.extraClassPath")
    sparkConf.remove("spark.executor.extraClassPath")
    sc.stop

    try {
      val sc = new SparkContext(sparkConf)

      //! Reading Amazon Kinesis with Spark Streaming
      //Setup the kinesis client
      val kinesisClient = new AmazonKinesisClient(
        new DefaultAWSCredentialsProviderChain()
      )
      kinesisClient.setEndpoint(endpointUrl)

      //Determine the number of shards from the stream
      val numShards = kinesisClient
        .describeStream(streamName)
        .getStreamDescription()
        .getShards()
        .size()

      //Create one worker per kinesis shard
      val ssc = new StreamingContext(sc, outputInterval)
      val kinesisStreams = (0 until numShards).map { i =>
        kinesisUtils.createStream(
          ssc,
          streamName,
          endpointUrl,
          outputInterval,
          InitialPositionInStream.TRIM_HORIZON,
          StorageLevel.MEMORY_ONLY
        )
      }

      //! Writing to Amazon S3 with Spark Streaming

      //Merge the worker Dstreams and translate the byteArray to string
      val unionStreams = ssc.union(kinesisStreams)
      val accessLogs = unionStreams.map(byteArray => new String(byteArray))

      //Write each RDD to Amazon S3
      accessLogs.foreachRDD((rdd, time) => {
        if (rdd.count > 0) {
          val outPartitionFolder = new java.text.SimpleDateFormat(
            "'year='month='MM/'day='dd/'hour='hh/'min='mm"
          ).format(new Date(time.milliseconds))

          rdd.saveAsTextFile(
            "%s%s".format(outputDir, outPartitionFolder),
            classOf[GzipCodec]
          )
        }
      })
      ssc.start()
      ssc.awaitTermination()

    } finally {
      ssc.stop(stopSparkContext = true, stopGracefully = true)
    }
  }
}
