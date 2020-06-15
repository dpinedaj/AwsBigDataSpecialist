
-- Return the first row in the stream
SELECT * FROM access_log_raw LIMIT 1;

-- Return count all items in the stream
SELECT COUNT(1) FROM  access_log_raw

-- Find the top 10 hosts
SELECT host, COUNT(1) FROM access_log_raw GROUP BY
host ORDER BY 2 DESC LIMIT 10;