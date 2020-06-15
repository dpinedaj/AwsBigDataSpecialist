CREATE EXTERNAL TABLE access_log_processed (
    request_time STRING,
    host STRING,
    request STRING,
    status INT,
    referred STRING,
    agent STRING
)
PARTITIONED BY (hour STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION 's3://YOUR-S3-BUCKET/access-log-processed';