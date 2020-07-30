drop table if exists hjj_temp2_20200720; commit;

create table hjj_temp2_20200720 
(
    serv_id numeric(21),  --用户id
    acc_nbr varchar(30),  --接入号
    prod_offer_id numeric(21),  --套餐号
    cust_id numeric(18),   --产权客户id
    cust_nbr varchar(30),  --产权客户号码
    cust_name varchar(160), --产权客户号
    subst_id numeric(18),   --放号局向
    grid_subst_id numeric(18),  --划小局向
    subst_id_kh numeric(10),   --客户局向
    branch_id numeric(18),   --营服id
    salestaff_id  varchar(100),  --揽装人id
    act_date date,    --受理时间
    subs_stat_date date,   --竣工时间
    create_date date,   --入网时间
    serv_grp_type varchar(10),   --服务分群
    channel_type_2011 varchar(30),  --渠道大类 
    channel_subtype_2011 varchar(30),--渠道小类
    zx_school int,   --校园中心
    branch_name varchar(200),  --营服中心
    sales_man_name varchar(100),  --揽装人名称
    sales_man_subst varchar(60),   --揽装人局向
    cdma_disc_name varchar(80),  
    vpn_value varchar(30),    --群号
    vpn_cust_code varchar(30),
    vpn_cust_name varchar(160),
    cust_type varchar(30),  --客户类型
    cnt_zx int
);
commit;

insert into hjj_temp2_20200720 
(serv_id,acc_nbr,prod_offer_id,cust_id,cust_nbr,cust_name,subst_id,grid_subst_id,subst_id_kh,branch_id,
salestaff_id,act_date,subs_stat_date,create_date,serv_grp_type,channel_type_2011,channel_subtype_2011,zx_school)
select serv_id,acc_nbr,prod_offer_id,cust_id,cust_nbr,cust_name,subst_id,grid_subst_id,subst_id_kh,branch_id,
salestaff_id,act_date,subs_stat_date,create_date,serv_grp_type,channel_type_2011,channel_subtype_2011,zx_school 
from rptdev.rpt_comm_ba_msdisc_union     --优惠订单表
where prod_offer_id=5730098
and action_id in (1292,6200)  --业务标识：1292-订购   6200-互换  1293-退订  1294-变更
and subs_stat='301200'
and subs_stat_reason not in ('1200','1300')
and subs_stat_date >= '20200701';
commit;

--营服中心
update  hjj_temp2_20200720 a
set a.branch_name=b.branch_name 
from bssdev.dim_branch b    --b: 营服维表
where a.branch_id=b.branch_id;
commit;

--揽装人名称、揽装人局向
update hjj_temp2_20200720 a
   set a.sales_man_name = b.sales_man_name,
       a.sales_man_subst = c.subst_name
  from bssdev.sales_man b, bssdev.sale_outlers c   --b：揽装人信息表 c：揽装机构信息表  统称：渠道统一视图
 where a.salestaff_id = b.sales_code
   and b.own_channel_id =c.channel_id;
commit;

--入网时办理的语音套餐
update hjj_temp2_20200720  a
set a.cdma_disc_name = c.cdma_disc_desc 
from bssdev.lst_ba_subs_cdma_new b,    --b：移动入网订单表  c:移动产品语音套餐维表
bssdev.md_ft_cdma_disc_config c
where a.serv_id=b.serv_id
and b.cdma_disc_id = c.cdma_disc_id;
commit;
update hjj_temp2_20200720  a
set a.cdma_disc_name = c.cdma_disc_desc 
from zwfxdev.lst_ba_subs_cdma_new b
,bssdev.md_ft_cdma_disc_config c
where a.serv_id=b.serv_id+89000000000000
and b.cdma_disc_id = c.cdma_disc_id
and a.cdma_disc_name is null;
commit;

--服务分群
update hjj_temp2_20200720 a
set a.serv_grp_type=b.serv_grp_type
from rptdev.rpt_comm_cm_serv_cdma_union b  --b：移动在用用户资料表
where b.month_id=202007
and a.serv_id=b.serv_id;
commit;

--VPN群号
update hjj_temp2_20200720 a
set a.create_date=b.finish_date,
a.vpn_value=b.vpn_value
from rptdev.rpt_comm_cm_serv_cdma_union b
where b.month_id=202007
and a.serv_id=b.serv_id;
commit;

--VPN群对应群名
update hjj_temp2_20200720 a
set a.vpn_cust_name=c.custgrp_name
,a.vpn_cust_code=b.cust_code
from bssdev.tb_mo_ivpn b,bssdev.tb_mo_custgrp_cust c  --b：VPN群表，c:产权客户和直销客户的关系表
where a.vpn_value=b.vpn_value
and b.cust_code=c.custgrp_code;
commit;

--政企客户类型1
update hjj_temp2_20200720 a
set a.cust_type=case when a.zx_school>0 then '校园' else '其他' end ;
commit;
--政企客户类型2
update hjj_temp2_20200720 a
set a.cust_type=case when c.vip_flag='TRUE' then '大客户'
when c.vip_flag ='001' then '高值商客'
when c.vip_flag in('FALSE','1') then '普通商客' else '其他' end
from bssdev.tb_mo_custgrp_cust b,bssdev.ecust_gz_mo_ccust c    --b：产权客户和直销客户的关系表，c:直销客户信息维表
where a.cust_id=b.cust_id
and b.custgrp_code=c.ccust_code
and (a.zx_school=0 or a.zx_school is null);
commit;

--同产权专线数量
select cust_id,count(distinct serv_id) cnt1 into #hjj_temp2_202007202  --该产权id有多少个用户
from bssdev.rpt_comm_cm_serv where prod_id in (57,1100)     --用户资料表
group by cust_id;
commit;

update hjj_temp2_20200720 a
set a.cnt_zx=b.cnt1
from #hjj_temp2_202007202 b
where a.cust_id=b.cust_id;
commit;

--同产权专线上月收入
alter table hjj_temp2_20200720 add fee_zx numeric(12,2)
select cust_nbr,sum(isnull(charge,0))/100 fee_zx into #hjj_temp2_202007202
from zwfxdev.f_sure_data_list_now where prod_id in (57,1100)   --后付费表
group by cust_nbr;
commit;

update hjj_temp2_20200720 a 
set a.fee_zx=b.fee_zx 
from #hjj_temp2_202007202 b 
where a.cust_nbr=b.acc_nbr;
commit;


--是否乐享主卡、合约、5G
alter table hjj_temp2_20200720 add (is_lx varchar(10),is_hy varchar(10),is_5G varchar(10))
update hjj_temp2_20200720 a 
set a.is_lx= case when b.is_lx = 1 then '是' else '否' end,
a.is_hy= b.is_contract,
a.is_5G=case when b.is_5G_disc = 1 then '是' else '否' end  
from rptdev.rpt_daily_cdma_dds_list_prodtype_union b  --b：移动用户的产品清单表
where b.month_id=202007 
and a.serv_id=b.serv_id;
commit;

--是否有效入网
alter table hjj_temp2_20200720 add is_yx varchar(10)
update hjj_temp2_20200720 a
set a.is_yx = '否';
commit;
update hjj_temp2_20200720 a
set a.is_yx = '是'
from rptdev.RPT_DAILY_CDMA_DDS_LIST_YD_YX_DAY b  --b：移动存量日有效表
where b.month_id = 202007
and a.serv_id = b.serv_id
and b.is_yx=1;
commit;

--是否携号转入
alter table hjj_temp2_20200720 add is_xr varchar(10)
update hjj_temp2_20200720 a
set a.is_xr = '否';
commit;
update hjj_temp2_20200720 a
set a.is_xr = '是'
from bssdev.RPT_COMM_CM_PROD_ATTR b  --b：产品特性到达数资料表
where b.attr_id = 500032046 
AND b.attr_value1 in ('001','002')
and convert(date,b.attr_create_date)>='20191110'
and a.serv_id=b.serv_id;
commit;

--政企团购登记信息
alter table hjj_temp2_20200720 add zqtg_info varchar(1024)
update hjj_temp2_20200720 a
set a.zqtg_info = b.PARAM_VALUE
from bssdev.rpt_comm_cm_msparam b    -- 优惠参数资料表
where a.serv_id = b.serv_id
and b.PARAM_CODE='SZX20191022' 
and b.prod_offer_id in (500051100,500051102,500051104)
;commit;

--导入多列数据  
drop table if exists dim_mbkh ;commit;
create table dim_mbkh (
cust_code varchar(30),
cust_name varchar(180),
cust_subst varchar(80)
);
commit;

truncate table dim_mbkh ;
commit;
LOAD TABLE dim_mbkh(
cust_name     '\x09',
cust_subst     '\x0a') 
USING CLIENT FILE 'X:\目标客户名称.txt' 
QUOTES OFF
ESCAPES OFF
WITH CHECKPOINT ON;
COMMIT; 
---清除无用符号
update dim_mbkh set cust_name = replace(cust_name,CHAR(9),''), cust_subst = replace(cust_subst,CHAR(9),'');
update dim_mbkh set cust_name = replace(cust_name,CHAR(10),''),cust_subst = replace(cust_subst,CHAR(10),'');
update dim_mbkh set cust_name = replace(cust_name,CHAR(13),''),cust_subst = replace(cust_subst,CHAR(13),'');
commit;

--是否目标客户
update hjj_temp2_20200720
set is_mb='否';
commit;


/*
update hjj_temp2_20200720
set is_mb='否';
commit;

update hjj_temp2_20200720  a
set a.is_mb = '是'
from bssdev.tb_mo_custgrp_cust b,dim_acc_nbr_gz5 c
where a.cust_id = b.cust_id
and b.custgrp_code=c.cust_code
;commit;

update hjj_temp2_20200720  a
set a.is_mb = '是'
from dim_acc_nbr_gz5 b
where a.is_mb = '否'
and a.vpn_cust_code=b.cust_code
;commit;
*/
