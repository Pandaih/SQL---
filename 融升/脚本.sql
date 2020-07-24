drop  table if exists hjj_temp2_20200720

--当月受理YD0203-082的号码 
select serv_id,acc_nbr,prod_offer_id 
into hjj_temp2_20200720 from  bssdev.rpt_comm_ba_msdisc a,  bssdev.offer b 
where a.prod_offer_id=b.offer_id 
and b.prod_offer_code in ('YD0203-082')
commit;

--客户名称、放号局向、客户局向、划小局向、落地营服id、揽装人id
alter table hjj_temp2_20200720 add (cust_name varchar(180),subst_id numeric(18),subst_id_kh numeric(10),
grid_subst_id numeric(18),branch_id numeric(18),salestaff_id  varchar(100));
update hjj_temp2_20200720 a 
set a.cust_name = b.cust_name ,
a.subst_id = b.subst_id ,
a.subst_id_kh = b.subst_id_kh ,
a.grid_subst_id = b.grid_subst_id ,
a.branch_id = b.branch_id,
a.salestaff_id = b.salestaff_id
from bssdev.rpt_comm_cm_serv b 
where a.acc_nbr=b.acc_nbr
commit;

--营服中心
alter table hjj_temp2_20200720 add branch_name varchar(200)
update  hjj_temp2_20200720 a
set a.branch_name=b.branch_name 
from bssdev.dim_branch b 
where a.branch_id=b.branch_id
commit;

--揽装人名称、揽装人局向
alter table hjj_temp2_20200720 add (sales_man_name varchar(100),sales_man_subst varchar(60) )
update hjj_temp2_20200720 a
   set a.sales_man_name = b.sales_man_name,
       a.sales_man_subst = c.subst_name
  from bssdev.sales_man b, bssdev.sale_outlers c 
 where a.salestaff_id = b.sales_code
   and b.own_channel_id =c.channel_id
;commit;

--082标识受理时间、竣工时间、入网时间
alter table hjj_temp2_20200720 add (act_date date,subs_stat_date date,create_date date )
update hjj_temp2_20200720 a
set a.act_date=b.act_date,
a.subs_stat_date=b.subs_stat_date,
a.create_date=b.create_date
from bssdev.rpt_comm_ba_msdisc b 
where a.acc_nbr=b.acc_nbr
commit;

--入网时办理的语音套餐  bssdev.LST_BA_SUBS_CDMA_NEW  

--服务分群
alter table hjj_temp2_20200720 add serv_grp_type varchar(10)
update hjj_temp2_20200720 a 
set a.serv_grp_type=b.serv_grp_type 
from bssdev.rpt_comm_cm_serv b 
where a.acc_nbr=b.acc_nbr

--VPN群号
alter table hjj_temp2_20200720 add vpn_value varchar(50)
update hjj_temp2_20200720 a 
set a.vpn_value =b.vpn_value 
from bssdev.rpt_comm_cm_serv b 
where a.acc_nbr=b.acc_nbr

--VPN群名
alter table hjj_temp2_20200720 add vpn_name varchar(160)
update hjj_temp2_20200720  a
set a.vpn_name = c.ccust_name 
from  bssdev.ECUST_GZ_MO_IVPN  b,bssdev.ECUST_GZ_MO_CCUST  c  --b表：VPN群  c表：客户资料表
where b.ivpn_code = c.ccust_code
and a.vpn_value = b.acc_nbr --VPN群号：vpn_value
and b.month_id = 202007
and c.month_id = 202007;
commit;

--渠道大类、小类
alter table hjj_temp2_20200720 add (channel_type_2011 varchar(30),channel_subtype_2011 varchar(30))
update hjj_temp2_20200720 a 
set a.channel_type_2011=b.channel_type_2011,
a.channel_subtype_2011=b.channel_subtype_2011 
from bssdev.rpt_comm_cm_serv b 
where a.acc_nbr=b.acc_nbr
commit;

--政企客户类型
