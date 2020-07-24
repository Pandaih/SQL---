drop table if exists hjj_temp_20200720 ;commit;
create table hjj_temp_20200720 (
acc_nbr varchar(30),
);
commit;

truncate table hjj_temp_20200720 ;commit;
LOAD TABLE hjj_temp_20200720(
acc_nbr       '\x0a')   
USING CLIENT FILE 'X:\123.txt' 
QUOTES OFF
ESCAPES OFF
WITH CHECKPOINT ON;
COMMIT; 
---清除无用符号
update hjj_temp_20200720 set acc_nbr = replace(acc_nbr,CHAR(9),'');
update hjj_temp_20200720 set acc_nbr = replace(acc_nbr,CHAR(10),'');
update hjj_temp_20200720 set acc_nbr = replace(acc_nbr,CHAR(13),'');
commit;

alter table hjj_temp_20200720 add cust_code varchar(50)
alter table hjj_temp_20200720 add bevy_cust_code varchar(20)

update hjj_temp_20200720 a 
set a.cust_code= b.cust_code
from bssdev.rpt_comm_cm_serv b 
where a.acc_nbr= b.acc_nbr ;
commit;

update hjj_temp_20200720 a 
set a.bevy_cust_code= b.bevy_cust_code
from bssdev.rpt_comm_cm_serv b 
where a.acc_nbr= b.acc_nbr ;
commit;

select * from hjj_temp_20200720
