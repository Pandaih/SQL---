-- begin
-- declare @vcsql varchar(1000);
-- declare @month_id integer; 
--     set @month_id = 201901; --更新开始月份
--   while @month_id<= 202002 loop
---获取收入数据
drop table if exists xb_temp1;commit;
select month_id,serv_id,acc_nbr,prod_id,GRID_SUBST_NAME,GRID_BRANCH_NAME,
       sum(isnull(a0,0)) as FEE,sum(isnull(a0,0)-tax_charge) as FEE_TAX
  into xb_temp1
  from zwfxdev_mid.rpt_hx_srqr_ts_bak
 where month_id = 202007
   and seq_id <> 79
   and prod_id in (48,57,2507,2508,2509,33,34,35,36,37,43,44,54,80,104,105,150,151,218,219,628,768,769,2347,500001081,
   350,351,352,501,682,2526,2527,3000,500000640,500001161,1054,1055,1057,2353,2355,500000306,500000382,500002221,2350,2541,
   3333,142600,500002482,58,681,2301,2302,2311,2312,2313,2314,2315,2316,2317,3812,500001520,500002640)
 group by month_id,serv_id,acc_nbr,prod_id,GRID_SUBST_NAME,GRID_BRANCH_NAME
 ;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||202007|| '获取收入数据 :' ||@@ROWCOUNT||' 条' type info to client;

----产品名称打标
alter table xb_temp1  add product varchar(20);commit;
update xb_temp1
set product= 
case when prod_id in (48,57,2507,2508,2509) then 'IP专线'
when prod_id in (33,34,35,36,37,43,44,54,80,104,105,150,151,218,219,628,768,769,2347,500001081) then '组网专线'
when prod_id in (350,351,352,501,682,2526,2527,3000,500000640,500001161,1054,1055,1057,2353,2355,500000306,500000382,500002221) then 'ICT'
when prod_id in (2350,2541,3333,142600,500002482) then '呼叫中心'
when prod_id in (58,681,2301,2302,2311,2312,2313,2314,2315,2316,2317,3812,500001520,500002640) then 'IDC'
else null end;
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||202007|| '产品名称打标 :' ||@@ROWCOUNT||' 条' type info to client;

----获取直销/产权信息
alter table xb_temp1 add(custgrp_code varchar(20),serv_grp_type varchar(100),cust_nbr varchar(30),cust_name varchar(160));commit;

update xb_temp1 a
   set a.custgrp_code = b.cust_code,
       a.serv_grp_type = b.serv_grp_type,
       a.cust_nbr = b.cust_nbr,
       a.cust_name = b.cust_name
  from rptdev.rpt_comm_cm_serv_union b
 where a.serv_id = b.serv_id
   and a.month_id = 202007
   and b.month_id = 202007
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||202007|| '获取直销/产权信息 :' ||@@ROWCOUNT||' 条' type info to client;

-----获取细分市场、省校园标签
alter table xb_temp1  add (divide_market_dl varchar(100),IS_SCHOOL_MARKET_USER smallint);commit;
update xb_temp1 a
   set a.divide_market_dl = c.divide_market_6_dl_name,
       a.IS_SCHOOL_MARKET_USER=b.IS_SCHOOL_MARKET_USER
  from bssdev.tlcs_divide_market_new b,
       TB_DIM_DIVIDE_MARKET_6 c 
 where a.month_id = 202007
   and b.month_id = 202007
   and a.serv_id=b.serv_id
   and b.divide_market = c.divide_market_6
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||202007|| '获取细分市场、省校园标签 :' ||@@ROWCOUNT||' 条' type info to client;

---插入直销名称
alter table xb_temp1 add custgrp_name varchar(100);commit;
update xb_temp1 a
set a.custgrp_name=b.custgrp_name
from bssdev.TB_MO_CUSTGRP_CUST b
where a.custgrp_code=b.custgrp_code
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||202007|| '更新直销名称 :' ||@@ROWCOUNT||' 条' type info to client;

delete from xb_temp2 where month_id = 202007;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||202007|| '删除数据 :' ||@@ROWCOUNT||' 条' type info to client;

insert into xb_temp2 
select * from xb_temp1;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||202007|| '插入数据 :' ||@@ROWCOUNT||' 条' type info to client;

set 202007=cast(dateformat(dateadd(month,1,convert(date,convert(varchar,202007)||'01')),'yyyymm') as integer); 
end loop;
end;

select month_id,product,serv_grp_type,IS_SCHOOL_MARKET_USER,divide_market_dl,
acc_nbr,GRID_SUBST_NAME,GRID_BRANCH_NAME,custgrp_code,custgrp_name,
cust_nbr,FEE_TAX
from xb_temp2 where serv_grp_type='01' and divide_market_dl not in ('行业客户') and IS_SCHOOL_MARKET_USER =0