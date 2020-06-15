CREATE EXTERNAL TABLE access_log_raw(
    host STRING, identity STRING,
    user STRING, request_time STRING,
    request STRING, status STRING,
    size STRING, referrer STRING,
    agent STRING
)
PARTITIONED BY (year INT, month INT, day INT, hour INT, min INT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
    "input.regex" = "([^ ]*) ([^ ]*) ([^ ]*) (-|\\[[^\\]]*\\]) ([^
    \"]*\"[^\"]*\") (-|[0-9]*) (-|[0-9]*)(?: ([^ \"]*|\"[^\"]*\") ([^
    \"]*|\"[^\"]*\"))?"
)
LOCATION 's3://YOUR-S3-BUCKET/access-log-raw';

msck repair table access_log_raw;