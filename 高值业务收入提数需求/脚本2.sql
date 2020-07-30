drop table if exists  hjj_temp_20200728
--获取数据
select month_id,serv_id,acc_nbr,prod_id,GRID_SUBST_NAME,GRID_BRANCH_NAME,
       sum(isnull(a0,0)) as FEE,sum(isnull(a0,0)-tax_charge) as FEE_TAX
  into hjj_temp_20200728
  from zwfxdev_mid.rpt_hx_srqr_ts_bak  --收入表
 where month_id = 202006
   and seq_id <> 79
 group by month_id,serv_id,acc_nbr,prod_id,GRID_SUBST_NAME,GRID_BRANCH_NAME

alter table hjj_temp_20200728 add (custgrp_code varchar(50),serv_grp_type varchar(10), cust_nbr varchar(30),cust_name varchar(160),divide_market_dl varchar(30));commit;
 --获取直销编码、服务分群、产权客户编码、产权客户名
update hjj_temp_20200728 a 
   set a.custgrp_code = b.cust_code,
       a.serv_grp_type = b.serv_grp_type,
       a.cust_nbr = b.cust_nbr,
       a.cust_name = b.cust_name
  from rptdev.rpt_comm_cm_serv_union b  
 where a.serv_id = b.serv_id
   and a.month_id = 202006
   and b.month_id = 202006
;commit;
--六大细分市场
update hjj_temp_20200728 a
   set a.divide_market_dl = c.divide_market_6_dl_name
  from bssdev.tlcs_divide_market_new b,  --细分市场
       TB_DIM_DIVIDE_MARKET_6 c   --六大细分市场信息维表
 where a.month_id = 202006
   and b.month_id = 202006
   and a.serv_id=b.serv_id
   and b.divide_market = c.divide_market_6
;commit;
--省校园标签
alter table hjj_temp_20200728 add IS_SCHOOL_MARKET_USER numeric(1);commit;
update hjj_temp_20200728 a 
set a.IS_SCHOOL_MARKET_USER=b.IS_SCHOOL_MARKET_USER 
from bssdev.tlcs_divide_market_new b 
where a.serv_id=b.serv_id;
commit;

--产品名 prod_number
alter table hjj_temp_20200728 add prod_number varchar(100) null ;commit;
update hjj_temp_20200728 a 
set a.prod_number =case when prod_id in (48,57,2507,2508,2509) then 'IP专线'
                        when prod_id in (33,34,35,36,37,43,44,54,80,104,105,150,151,218,219,628,768,769,2347,500001081) then '组网专线'
                        when prod_id in (350,351,352,501,682,2526,2527,3000,500000640,500001161,1054,1055,1057,2353,2355,500000306,500000382,500002221) then 'ICT'
                        when prod_id in (2350,2541,3333,142600,500002482) then '呼叫中心'
                        when prod_id in (58,681,2301,2302,2311,2312,2313,2314,2315,2316,2317,3812,500001520,500002640) then 'IDC'
                    else '-' end;
                    commit;
--删除‘-’的数据
delete from hjj_temp_20200728 where  prod_number in ('-');commit;

--直销名称
alter table hjj_temp_20200728 add custgrp_name varchar(100);commit;
update hjj_temp_20200728 a
set a.custgrp_name=b.custgrp_name
from bssdev.TB_MO_CUSTGRP_CUST b
where a.custgrp_code=b.custgrp_code
;commit;

--到期时间
alter table hjj_temp_20200728 add limit_date date;commit;
update hjj_temp_20200728 a 
set a.limit_date=b.limit_date 
from rptdev.rpt_comm_cm_msdisc_union  b 
where b.month_id=202006 
and  a.acc_nbr=b.acc_nbr
and a.prod_id=b.prod_id 

-- 1.取全部服务分群为政企的
delete from hjj_temp_20200728 where serv_grp_type <>'01';commit;
delete from hjj_temp_20200728 where serv_grp_type is null;commit;
-- 2.剔除省校园标签为'是'的 
 delete from hjj_temp_20200728 where IS_SCHOOL_MARKET_USER >0;commit;
-- 3.剔除六大细分市场为'行客市场'
delete from hjj_temp_20200728  where divide_market_dl in ('行业客户');commit;

select month_id,prod_number,serv_grp_type,IS_SCHOOL_MARKET_USER,divide_market_dl,
acc_nbr,GRID_SUBST_NAME,GRID_BRANCH_NAME,limit_date,cust_nbr,cust_name,custgrp_code,custgrp_name,FEE_TAX 
from hjj_temp_20200728 


