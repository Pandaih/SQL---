--导入数据
drop table if exists hjj_temp_20200724 ;commit;
create table hjj_temp_20200724 (
prod_offer_code varchar(50),
acc_nbr varchar(30),
limit_date date
);
commit;
truncate table hjj_temp_20200724 ;
commit;
LOAD TABLE hjj_temp_20200724(
prod_offer_code     '\x09',
acc_nbr     '\x09',
limit_date  '\x0a') 
USING CLIENT FILE 'X:\111.txt' 
QUOTES OFF
ESCAPES OFF
WITH CHECKPOINT ON;
COMMIT; 
---清除无用符号
update hjj_temp_20200724 set prod_offer_code = replace(prod_offer_code,CHAR(9),''), acc_nbr = replace(acc_nbr,CHAR(9),'');
update hjj_temp_20200724 set prod_offer_code = replace(prod_offer_code,CHAR(10),''),acc_nbr = replace(acc_nbr,CHAR(10),'');
update hjj_temp_20200724 set prod_offer_code = replace(prod_offer_code,CHAR(13),''),acc_nbr = replace(acc_nbr,CHAR(13),'');
commit;
--serv_id
alter table hjj_temp_20200724 add serv_id numeric(20) 
update hjj_temp_20200724 a
set a.serv_id=b.serv_id 
from bssdev.RPT_COMM_CM_SERV_2020 b 
where a.acc_nbr=b.acc_nbr 
and month_id=202006
;commit;
--prod_offer_id
alter table hjj_temp_20200724 add prod_offer_id numeric(12)
update hjj_temp_20200724 a 
set a.prod_offer_id=b.offer_id
from bssdev.offer b
where a.prod_offer_code=b.prod_offer_code 
--更新
alter  table  hjj_temp_20200724 add msinfo_id numeric(21)
update hjj_temp_20200724 a
set a.msinfo_id=b.msinfo_id
from rptdev.rpt_comm_cm_msdisc_union b
where b.month_id=202007
and a.serv_id=b.serv_id
and a.prod_offer_id=b.prod_offer_id
and a.limit_date=b.limit_date
;commit;