--导入数据
drop table if exists hjj_temp_20200729 ;commit;
create table hjj_temp_20200729 (
bevy_cust_id int,
staff_id numeric(21),
staff_name varchar(1000),
salestaff_code varchar(120),
staff_code varchar(1000),
mobile_nbr varchar(50)
);
commit;
truncate table hjj_temp_20200729 ;
commit;
LOAD TABLE hjj_temp_20200729(
bevy_cust_id    '\x0a') 
USING CLIENT FILE 'X:\111.txt' 
QUOTES OFF
ESCAPES OFF
WITH CHECKPOINT ON;
COMMIT; 
--staff_id、手机号码
update hjj_temp_20200729 a 
set a.staff_id=b.staff_id, 
a.mobile_nbr=b.mobile_nbr
from bssdev.f_cms_bevy_cust_staff b  --网格经理、直销客户关系维表
where a.bevy_cust_id=b.bevy_cust_id 
--揽装编码，揽装工号
update hjj_temp_20200729 a 
set a.salestaff_code=b.salesstaff_code,
a.staff_code=b.staff_code,
a.staff_name=b.staff_name
from bssdev.staff b    --员工信息维表
where a.staff_id=b.staff_id   

select  *  from bssdev.f_cms_bevy_cust_staff where bevy_cust_id=1000047941

select count(a.staff_id) as 数量 from bssdev.f_cms_bevy_cust_staff a where 
