CREATE TABLE accesslogs (
    request_time TIMESTAMP,
    host VARCHAR(50),
    request VARCHAR(1024),
    status int,
    referrer VARCHAR(1024),
    agent VARCHAR(1024)
)
DISTKEY(host)
SORTKEY(request_time);