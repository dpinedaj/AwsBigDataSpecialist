COPY accesslogs
FROM 's3://MY-BUCKET-NAME/access-log-processed'
CREDENTIALS
    'aws_access_key_id=MY-AWS-KEY-ID; aws_secret_access_key=MY-AWS-SECRET-KEY'
DELIMITER '\t' IGNOREHEADER 0
MAXERROR 0
GZIP;