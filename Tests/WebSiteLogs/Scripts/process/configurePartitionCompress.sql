--setup Hive's dynamic partitioning
--this will split ouput files when writing to Amazon S3

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.dynamic.partition=true;


--compress output files on Amazon S3 using Gzip
SET mapred.output.compress=true;
SET hive.exec.compress.output=true;
SET mapred.output.compression.codec=
org.apache.hadoop.io.compress.GzipCodec;
SET io.compression.codecs=org.apache.hadoop.io.compress.GzipCodec;