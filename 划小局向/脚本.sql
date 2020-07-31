--导入数据
drop table if exists hjj_temp_20200731 ;commit;
create table hjj_temp_20200731 (
acc_nbr varchar(30),
grid_subst_id numeric(18)
);
commit;
truncate table hjj_temp_20200731 ;
commit;
LOAD TABLE hjj_temp_20200731(
acc_nbr     '\x0a') 
USING CLIENT FILE 'X:\123.txt' 
QUOTES OFF
ESCAPES OFF
WITH CHECKPOINT ON;
COMMIT; 
---清除无用符号
update hjj_temp_20200731 set acc_nbr = replace(acc_nbr,CHAR(9),'');
update hjj_temp_20200731 set acc_nbr = replace(acc_nbr,CHAR(10),'');
update hjj_temp_20200731 set acc_nbr = replace(acc_nbr,CHAR(13),'');
commit;
--划小局向id
update hjj_temp_20200731 a 
set a.grid_subst_id=b.grid_subst_id 
from bssdev.RPT_COMM_CM_SERV_2019 b 
where a.acc_nbr=b.acc_nbr
and b.month_id=201912;
;commit;
--划小局向名称
alter table hjj_temp_20200731 add grid_subst_name varchar(60)
update hjj_temp_20200731 a 
set a.grid_subst_name=b.aliasname 
from bssdev.dim_subst b 
where a.grid_subst_id=b.subst_id 
;commit;
--201912匹配不上，继续匹配
update hjj_temp_20200731 a 
set a.grid_subst_id=b.grid_subst_id 
from bssdev.RPT_COMM_CM_SERV_2019 b 
where a.acc_nbr=b.acc_nbr
and b.month_id=201911
and a.acc_nbr is null;
;commit;