select query, substring(filename,22,25) as filename,line_number as line, 
substring(colname,0,12) as column, type, position as pos, substring(raw_line,0,30) as line_text,
substring(raw_field_value,0,15) as field_text, 
substring(err_reason,0,45) as reason
from stl_load_errors 
order by query desc
limit 10;

select p_partkey, p_name, p_mfgr, p_category from part where p_mfgr is null;

select query, substring(filename,22,25) as filename,line_number as line, 
substring(colname,0,12) as column, type, position as pos, substring(raw_line,0,30) as line_text,
substring(raw_field_value,0,15) as field_text, 
substring(err_reason,0,45) as error_reason
from stl_load_errors 
order by query desc, filename 
limit 7;

select c_custkey, c_name, c_address        
from customer
order by c_custkey
limit 10;

