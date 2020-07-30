--导入数据
drop table if exists hjj_temp_20200727 ;commit;
create table hjj_temp_20200727 (
acc_nbr varchar(30),
serv_id numeric (21),
prod_id int
);
commit;
truncate table hjj_temp_20200727 ;
commit;
LOAD TABLE hjj_temp_20200727(
acc_nbr     '\x09',
serv_id     '\x09',
prod_id  '\x0a') 
USING CLIENT FILE 'X:\111.txt' 
QUOTES OFF
ESCAPES OFF
WITH CHECKPOINT ON;
COMMIT; 
---清除无用符号
update hjj_temp_20200727 set acc_nbr = replace(acc_nbr,CHAR(9),'');
update hjj_temp_20200727 set acc_nbr = replace(acc_nbr,CHAR(10),'');
update hjj_temp_20200727 set acc_nbr = replace(acc_nbr,CHAR(13),'');
commit;
--cust_id,cust_name 
alter table hjj_temp_20200727 add (cust_id numeric (18),cust_name varchar(160));commit;
update hjj_temp_20200727 a
set a.cust_id=b.cust_id,a.cust_name=b.cust_name 
from bssdev.rpt_comm_cm_serv b 
where a.serv_id=b.serv_id 
and b.month_id=202007
;commit;
--ccust_code ,ccust_name
alter table hjj_temp_20200727 add (ccust_code varchar(160),ccust_name varchar(4000));commit;
update hjj_temp_20200727 a
set a.ccust_code=b.ccust_code,
a.ccust_name=b.ccust_name
from bssdev.ecust_gz_mo_ccust b
where a.cust_id=b.cust_id
;commit;
--脱敏2
update hjj_temp_20200727
set cust_name =(case when cust_name is not null then substr(cust_name,1,2)||'******'||substr(cust_name,9) else null end)
;commit;
update hjj_temp_20200727
set ccust_name =(case when ccust_name is not null then substr(ccust_name,1,2)||'******'||substr(ccust_name,9) else null end)
;commit;


--脱敏1
-- select replace(cust_name,substr(cust_name,3,5),'*****') as cust_name2 from hjj_temp_20200727
-- select replace(ccust_name,substr(ccust_name,3,5),'*****') as ccust_name2 from hjj_temp_20200727
