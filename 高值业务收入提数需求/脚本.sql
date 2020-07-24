drop table  if exists hjj_temp_20200716

select month_id,serv_id,acc_nbr,prod_id,GRID_SUBST_NAME,GRID_BRANCH_NAME,
       sum(isnull(a0,0)) as FEE,sum(isnull(a0,0)-tax_charge) as FEE_TAX
  into hjj_temp_20200716
  from zwfxdev_mid.rpt_hx_srqr_ts_bak -- 收入表
 where month_id = 202006 
   and seq_id <> 79  --切割条件
 group by month_id,serv_id,acc_nbr,prod_id,GRID_SUBST_NAME,GRID_BRANCH_NAME,GRID_BRANCH_NAME


alter table hjj_temp_20200716 add (custgrp_code varchar(50),serv_grp_type varchar(10), cust_nbr varchar(30) ,cust_name varchar(160));commit;

update hjj_temp_20200716 a
   set a.custgrp_code = b.cust_code,
       a.serv_grp_type = b.serv_grp_type,
       a.cust_nbr = b.cust_nbr,
       a.cust_name = b.cust_name
  from rptdev.rpt_comm_cm_serv_union b  --用户资料信息表
 where a.serv_id = b.serv_id
   and a.month_id =202006
   and b.month_id =202006
;commit;

alter table hjj_temp_20200716 add divide_market_dl varchar(30)


alter table hjj_temp_20200716 add prod_number varchar(30) 
update hjj_temp_20200716 a
set a.prod_number =case when prod_id in (48,57,2507,2508,2509) then 'IP专线'
                        when prod_id in (33,34,35,36,37,43,44,54,80,104,105,150,151,218,219,628,768,769,2347,500001081) then '组网专线'
                        when prod_id in (350,351,352,501,682,2526,2527,3000,500000640,500001161,1054,1055,1057,2353,2355,500000306,500000382,500002221) then 'ICT'
                        when prod_id in (2350,2541,3333,142600,500002482) then '呼叫中心'
                        when prod_id in (58,681,2301,2302,2311,2312,2313,2314,2315,2316,2317,3812,500001520,500002640) then 'IDC'
else '-' end;
commit;
 delete from hjj_temp_20200716 where serv_id in (select serv_id from  bssdev.tlcs_divide_market_new where IS_SCHOOL_MARKET_USER >0 );commit;

select  * from hjj_temp_20200716 
 hjj_temp_20200716 where serv_grp_type='01' and prod_number <> '-'



select * from hjj_temp_20200716 where serv_grp_type='01' and prod_number <> '-' and divide_market_dl is not null

