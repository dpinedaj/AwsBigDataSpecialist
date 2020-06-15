--find distribution of status codes over days
SELECT TRUNC(request_time), status, COUNT(1) 
FROM accesslogs
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

--find the 404 status codes
SELECT COUNT(1) FROM accessLogs WHERE status = 404;

--show all requests for status as PAGE NOT FOUND
SELECT TOP 1 request, COUNT(1)
FROM accesslogs
WHERE status = 404
GROUP BY 1
ORDER BY 2 DESC;