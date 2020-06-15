--convert the Apache log timestamp to a UNIX timestamp
--split files in Amazon S3 by the hour in the log lines
INSERT OVERWRITE TABLE access_log_processed PARTITION (hour)
    SELECT
        from_unixtime(unix_timestamp(request_time,
        '[dd/MMM/yyyy:HH:mm:ss Z')),
        host,
        request,
        status,
        referrer,
        agent,
        hour(from_unixtime(unix_timestamp(request_time,
        '[dd/MMM/yyyy:HH:mm:ss Z]'))) as hour
    FROM access_log_raw;