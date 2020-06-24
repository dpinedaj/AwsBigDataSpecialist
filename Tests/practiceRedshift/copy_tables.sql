--Copy part replacing null values as \000
copy part from 's3://<your-bucket-name>/load/part-csv.tbl' 
credentials 'aws_access_key_id=<Your-Access-Key-ID>;aws_secret_access_key=<Your-Secret-Access-Key>' 
csv
null as '\000';

--Load supplier using the region from a sample bucket
copy supplier from 's3://awssampledbuswest2/ssbgz/supplier.tbl' 
credentials 'aws_access_key_id=<Your-Access-Key-ID>;aws_secret_access_key=<Your-Secret-Access-Key>' 
delimiter '|' 
gzip
region 'us-west-2';

--Copy customer allowing max 10 errors as warnings, after it can query the errors to check it
copy customer
from 's3://<your-bucket-name>/load/customer-fw.tbl'
credentials 'aws_access_key_id=<Your-Access-Key-ID>;aws_secret_access_key=<Your-Secret-Access-Key>' 
fixedwidth 'c_custkey:10, c_name:25, c_address:25, c_city:10, c_nation:15, c_region :12, c_phone:15,c_mktsegment:10'
maxerror 10;

--Copy customer data using the manifest which specifies each part into the s3 bucket
copy customer from 's3://<your-bucket-name>/load/customer-fw-manifest'
credentials 'aws_access_key_id=<Your-Access-Key-ID>;aws_secret_access_key=<Your-Secret-Access-Key>' 
fixedwidth 'c_custkey:10, c_name:25, c_address:25, c_city:10, c_nation:15, c_region :12, c_phone:15,c_mktsegment:10'
maxerror 10 
acceptinvchars as '^'
manifest;

--Copy dwdate passing a dateformat as auto
copy dwdate from 's3://<your-bucket-name>/load/dwdate-tab.tbl'
credentials 'aws_access_key_id=<Your-Access-Key-ID>;aws_secret_access_key=<Your-Secret-Access-Key>' 
delimiter '\t' 
dateformat 'auto';

--To check the performance of the cluster loading
--multiple files
copy lineorder from 's3://awssampledb/load/lo/lineorder-single.tbl' 
credentials 'aws_access_key_id=<Your-Access-Key-ID>;aws_secret_access_key=<Your-Secret-Access-Key>' 
gzip
compupdate off
region 'us-east-1';

