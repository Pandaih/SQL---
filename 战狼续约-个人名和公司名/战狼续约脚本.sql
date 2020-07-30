drop table if exists temp_20200714;commit;
--建临时表
create table temp_20200714  
(
serv_id numeric(21),  -- 服务标识
acc_nbr varchar(30),  -- 号码
cust_name varchar(100), -- 产权客户名称
prod_id int,          -- 产品号 3204 3205表示移动产品
prod_offer_id numeric(12),    -- 套餐号
prod_offer_code varchar(50),  --套餐名编码
prod_offer_name varchar(100), --套餐名
create_date date,   
limit_date date,
z_prod_offer_id numeric(12),  -- 主套餐号
z_prod_offer_code varchar(50), --主套餐编码
z_prod_offer_name varchar(100), --主套餐名
is_llcx int,  --备注
is_gsm int,  -- 公司名
param_value varchar(30), --参数值
prod_offer_number int    --序号
);
commit;

--插入赠金数据到临时表
insert into temp_20200714
(serv_id,acc_nbr,prod_id,prod_offer_id,prod_offer_code,prod_offer_name,create_date,limit_date)
select a.serv_id,a.acc_nbr,a.prod_id,a.prod_offer_id,b.prod_offer_code,b.offer_name,convert(varchar(30),dateformat(a.create_date,'yyyy-mm-dd')),
convert(varchar(30),dateformat(a.limit_date,'yyyy-mm-dd'))
from bssdev.RPT_COMM_CM_MSDISC a,bssdev.offer b
where a.prod_offer_id = b.offer_id
and b.prod_offer_code in('TG0003-002-1-3','TG0003-002-1-2','YD4G03-222-1-4','YD4G03-222-1-3','YD4G03-222-1-2','YD4G03-222-1-1','TG0003-001-1-1','YD0203-082','YD4G03-181-1-1','YD4G03-181-1-2','YD4G03-181-1-3','YD4G03-181-1-4','YD0203-476-1-1','YD0203-476-1-2','YD0203-476-1-3','YD0203-476-1-4')
and a.prod_id in(3204,3205)
and convert(varchar(30),dateformat(limit_date,'yyyy-mm-dd')) >= '2020-08-01'
commit;

--更新主套餐数据到临时表
update temp_20200714 a
set a.z_prod_offer_id = b.prod_offer_id,
a.z_prod_offer_code = c.prod_offer_code,
a.z_prod_offer_name = c.offer_name 
from bssdev.RPT_COMM_CM_MSDISC b,
bssdev.offer c 
where a.serv_id = b.serv_id 
and b.prod_offer_id = c.offer_id 
and b.prod_id in(3204,3205)
and b.prod_offer_id in(100089389,100096298,100096299,100096695,100096696);
commit;

--更新产权名数据到临时表
update temp_20200714 a
set a.cust_name = b.cust_name  --产权名字 是为了匹配公司名
from bssdev.rpt_comm_cm_serv b
where a.serv_id = b.serv_id 
and b.prod_id in(3204,3205);
commit;

--判断个人名和公司名
update temp_20200714 a
set a.is_gsm = case when length(a.cust_name) > 4 then 1 else 0 end;
commit;

--利用参数区分29元大战狼和19元大战狼
update temp_20200714 a
set a.param_value = null;
commit;

update temp_20200714 a
set a.param_value = b.param_value
from bssdev.rpt_comm_cm_msparam b,bssdev.offer c
where a.serv_id=b.serv_id
and a.prod_offer_id=c.offer_id 
and c.prod_offer_code='YD0203-082'
and a.z_prod_offer_code in('YD4G01-088-1-1')
and b.param_code='991100000725';
commit;

alter table temp_20200714 add prod_offer_name_new varchar(100) null ;commit;
update temp_20200714 a
set a.prod_offer_name_new = case when z_prod_offer_code in('YD4G01-096-1-1') and prod_offer_code in('TG0003-002-1-3') then '29元团购（5G降速）'
                                 when z_prod_offer_code in('YD4G01-096-1-2') and prod_offer_code in('TG0003-002-1-2') then '39元团购（10G降速）'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD4G03-222-1-4') then '49团购'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD4G03-222-1-3') then '59团购'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD4G03-222-1-2') then '69团购'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD4G03-222-1-1') then '79团购'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('TG0003-001-1-1') then '49元团购（赠金直降版）'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in ('YD0203-082') and param_value='1680' then '29元大战狼'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD0203-082')  and param_value='1920' then '19元大战狼'
                                 when z_prod_offer_code in('YD4G01-056-1-1') and prod_offer_code in('YD4G03-181-1-1') then '79元团购'
                                 when z_prod_offer_code in('YD4G01-056-1-1') and prod_offer_code in('YD4G03-181-1-2') then '69元团购'
                                 when z_prod_offer_code in('YD4G01-056-1-1') and prod_offer_code in('YD4G03-181-1-3') then '59元团购'
                                 when z_prod_offer_code in('YD4G01-056-1-1') and prod_offer_code in('YD4G03-181-1-4') then '49元团购'
                                 when z_prod_offer_code in('YD4G01-088-1-2') and prod_offer_code in('YD0203-476-1-1') then '199五折'
                                 when z_prod_offer_code in('YD4G01-088-1-2') and prod_offer_code in('YD0203-476-1-2') then '199六折'
                                 when z_prod_offer_code in('YD4G01-088-1-2') and prod_offer_code in('YD0203-476-1-3') then '199七折'
                                 when z_prod_offer_code in('YD4G01-088-1-2') and prod_offer_code in('YD0203-476-1-4') then '199八折'
else '-' end;
commit;

update temp_20200714 a
set a.prod_offer_number   = case when z_prod_offer_code in('YD4G01-096-1-1') and prod_offer_code in('TG0003-002-1-3') then '1'
                                 when z_prod_offer_code in('YD4G01-096-1-2') and prod_offer_code in('TG0003-002-1-2') then '2'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD4G03-222-1-4') then '3'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD4G03-222-1-3') then '4'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD4G03-222-1-2') then '5'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD4G03-222-1-1') then '6'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('TG0003-001-1-1') then '7'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in ('YD0203-082') and param_value='1680' then '8'
                                 when z_prod_offer_code in('YD4G01-088-1-1') and prod_offer_code in('YD0203-082')  and param_value='1920' then '9'
                                 when z_prod_offer_code in('YD4G01-056-1-1') and prod_offer_code in('YD4G03-181-1-1') then '10'
                                 when z_prod_offer_code in('YD4G01-056-1-1') and prod_offer_code in('YD4G03-181-1-2') then '11'
                                 when z_prod_offer_code in('YD4G01-056-1-1') and prod_offer_code in('YD4G03-181-1-3') then '12'
                                 when z_prod_offer_code in('YD4G01-056-1-1') and prod_offer_code in('YD4G03-181-1-4') then '13'
                                 when z_prod_offer_code in('YD4G01-088-1-2') and prod_offer_code in('YD0203-476-1-1') then '14'
                                 when z_prod_offer_code in('YD4G01-088-1-2') and prod_offer_code in('YD0203-476-1-2') then '15'
                                 when z_prod_offer_code in('YD4G01-088-1-2') and prod_offer_code in('YD0203-476-1-3') then '16'
                                 when z_prod_offer_code in('YD4G01-088-1-2') and prod_offer_code in('YD0203-476-1-4') then '17'
else '-' end;
commit;

select prod_offer_number,
prod_offer_name_new,z_prod_offer_code,prod_offer_code,count(distinct case when is_gsm=0 then serv_id end),
                                                                               count(distinct case when is_gsm=1 then serv_id end)
  from temp_20200714 where z_prod_offer_code is not null and prod_offer_number is not null group by prod_offer_number,
prod_offer_name_new,z_prod_offer_code,prod_offer_code 


/*
select prod_offer_name_new,
count(distinct case when is_gsm = 0 then serv_id else null end), 
count(distinct case when is_gsm = 1 then serv_id else null end)
from temp_20200714
group by prod_offer_name_new


select distinct b.serv_id,b.acc_nbr,b.prod_offer_id,c.offer_name,b.param_code,b.param_value,convert(varchar(30),dateformat(d.limit_date,'yyyy-mm-dd')) 
from bssdev.rpt_comm_cm_msparam b,bssdev.RPT_COMM_CM_MSDISC d,bssdev.offer c
where b.prod_offer_id = 5730098
and b.param_code='991100000725'
and b.param_value in('1680','1920')
and b.prod_id in(3204,3205)
and d.prod_offer_id = 5730098
and b.serv_id = d.serv_id
and b.prod_offer_id = c.offer_id

select * from bssdev.offer
where prod_offer_code like '%YD0203-082%'

select b.offer_name,a.param_value,a.* from bssdev.rpt_comm_cm_msparam a
,bssdev.offer b 
where a.prod_offer_id=b.offer_id
and b.prod_offer_code='YD0203-082'
and a.param_code='991100000725'


select b.offer_name,a.param_value,a.* from bssdev.rpt_comm_cm_msparam a
,bssdev.offer b 
where a.prod_offer_id=b.offer_id
and b.prod_offer_code='YD0203-082'
and a.param_code='991100000725'
*/