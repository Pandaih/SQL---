create PROCEDURE zhengqb.[SP_TB_ZQ_LFH_YDRH](in @sum_date integer default cast(dateformat(now()-1,'yyyymmdd') as integer)
,in @is_run_flag1 integer default 1
,in @is_run_flag2 integer default 10
)
/**********************************************************
--  Purpose：政企部融升3.0营销发展日清单
--  Auther：叶忠辉
--  Date：2020-07-16
--  Modified History
-- --------------------------------------------------------
--
--  输入参数：@sum_date
--  结果表：tb_zqb_lfh_ydrh_list
--
***********************************************************/
begin
declare @month_id int;
declare @sql1 varchar(3000);
set @month_id=@sum_date/100;
set temporary option conversion_error = 'OFF';
set temporary option Query_Temp_Space_Limit = 0;
------------------------------------------------------------基础清单生产开始---------------------------------------------------
message Dateformat(now(),'yyyymmdd hh:nn:ss') ||' 融升3.0营销发展日清单-生产开始 ' type info to client;
--初始化
truncate table tb_zqb_lfh_ydrh_list
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-初始化 :' ||@@ROWCOUNT||' 条' type info to client;
--go
if @is_run_flag1<=1 and @is_run_flag2>=1 then 
insert into tb_zqb_lfh_ydrh_list(sum_date,acc_nbr,serv_id,zx_school,cust_id,cust_nbr,cust_name,subst_id,grid_subst_id,branch_id,subst_id_kh,salestaff_id,act_date,subs_stat_date
,create_date,serv_grp_type,channel_type_2011,channel_subtype_2011)
select distinct dateformat(now(),'yyyymmdd') as sum_date,acc_nbr,serv_id,zx_school,cust_id,cust_nbr,cust_name,subst_id,grid_subst_id,branch_id,subst_id_kh,salestaff_id,act_date,subs_stat_date
,create_date,serv_grp_type,channel_type_2011,channel_subtype_2011
from rptdev.rpt_comm_ba_msdisc_union
where prod_offer_id=5730098
and action_id in (1292,6200)
and subs_stat='301200'
and subs_stat_reason not in ('1200','1300')
and subs_stat_date>='20200701'
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-基础数据生成：'||@@ROWCOUNT||' 条' type info to client;
--揽装人工号
update tb_zqb_lfh_ydrh_list as a
set a.salestaff_id = case when cast(a.salestaff_id as numeric(21)) = b.staff_id then b.sales_code else '-1' end
from bssdev.staff b
where cast(a.salestaff_id as numeric(21)) *= b.staff_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-揽装人编号：'||@@ROWCOUNT||' 条' type info to client;
--揽装人名称
update tb_zqb_lfh_ydrh_list a
set a.salestaff_name = b.sales_man_name
from bssdev.sales_man b
where a.salestaff_id = b.sales_code
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-揽装人名称 ：'||@@ROWCOUNT||' 条' type info to client; 
--揽装人所属局向
update tb_zqb_lfh_ydrh_list a
set a.sales_subst_name = c.subst_name
from bssdev.sales_man b,bssdev.sale_outlers c
where a.salestaff_id = b.sales_code
and b.own_channel_id=c.channel_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-揽装人所属局向 ：'||@@ROWCOUNT||' 条' type info to client; 
--同产权专线上月收入
--1
select cust_nbr,sum(isnull(charge,0))/100 fee_zx into #tb_zqb_lfh_ydrh_list1
from zwfxdev.f_sure_data_list_now where prod_id in (57,1100) 
group by cust_nbr
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-同产权专线上月收入中间表：'|| @@ROWCOUNT || ' 条' type info to client;
--2
update tb_zqb_lfh_ydrh_list a
set a.fee_zx=b.fee_zx
from #tb_zqb_lfh_ydrh_list1 b
where a.cust_nbr=b.cust_nbr
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新同产权专线上月收入：'|| @@ROWCOUNT || ' 条' type info to client;
--同产权专线数量
--1
select cust_id,count(distinct serv_id) cnt1 into #tb_zqb_lfh_ydrh_list2
from bssdev.rpt_comm_cm_serv where prod_id in (57,1100) 
group by cust_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-同产权专线数量中间表：'|| @@ROWCOUNT || ' 条' type info to client;
--2
update tb_zqb_lfh_ydrh_list a
set a.cnt_zx=b.cnt1
from #tb_zqb_lfh_ydrh_list2 b
where a.cust_id=b.cust_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新同产权专线数量：'|| @@ROWCOUNT || ' 条' type info to client;
--政企客户类型1
update tb_zqb_lfh_ydrh_list a
set a.cust_type=case when a.zx_school>0 then '校园' else '其他' end
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-政企客户类型（校园）：'|| @@ROWCOUNT || ' 条' type info to client;
--政企客户类型2
update tb_zqb_lfh_ydrh_list a
set a.cust_type=case when c.vip_flag='TRUE' then '大客户'
when c.vip_flag ='001' then '高值商客'
when c.vip_flag in('FALSE','1') then '普通商客' else '其他' end
from bssdev.tb_mo_custgrp_cust b,bssdev.ecust_gz_mo_ccust c
where a.cust_id=b.cust_id
and b.custgrp_code=c.ccust_code
and (a.zx_school=0 or a.zx_school is null)
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新政企客户类型：'|| @@ROWCOUNT || ' 条' type info to client;
--入网时办理的语音套餐
update tb_zqb_lfh_ydrh_list as a
set a.cdma_disc_name = c.cdma_disc_desc 
from bssdev.lst_ba_subs_cdma_new b
,bssdev.md_ft_cdma_disc_config c
where a.serv_id=b.serv_id
and b.cdma_disc_id = c.cdma_disc_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新入网时办理的语音套餐1：'|| @@ROWCOUNT || ' 条' type info to client;
update tb_zqb_lfh_ydrh_list as a
set a.cdma_disc_name = c.cdma_disc_desc 
from zwfxdev.lst_ba_subs_cdma_new b
,bssdev.md_ft_cdma_disc_config c
where a.serv_id=b.serv_id+89000000000000
and b.cdma_disc_id = c.cdma_disc_id
and a.cdma_disc_name is null
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新入网时办理的语音套餐2：'|| @@ROWCOUNT || ' 条' type info to client;
--服务分群/VPN群号
update tb_zqb_lfh_ydrh_list a
set a.create_date=b.finish_date
,a.serv_grp_type=b.serv_grp_type
,a.vpn_value=b.vpn_value
from rptdev.rpt_comm_cm_serv_cdma_union b
where b.month_id=@month_id
and a.serv_id=b.serv_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新服务分群/VPN群号：'|| @@ROWCOUNT || ' 条' type info to client;
--VPN群对应群名
update tb_zqb_lfh_ydrh_list a
set a.vpn_cust_name=c.custgrp_name
,a.vpn_cust_code=b.cust_code
from bssdev.tb_mo_ivpn b,bssdev.tb_mo_custgrp_cust c
where a.vpn_value=b.vpn_value
and b.cust_code=c.custgrp_code
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新VPN群对应群名：'|| @@ROWCOUNT || ' 条' type info to client;
--入网类型（新入网/存量续约）
update tb_zqb_lfh_ydrh_list a 
set a.rw_type=case when (datediff(dd,subs_stat_date,create_date)+1)>=-30 and (datediff(dd,subs_stat_date,create_date)+1)<=30 then '新入网' else '存量续约' end
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新入网类型（新入网/存量续约）：'|| @@ROWCOUNT || ' 条' type info to client;
--划小局向
update tb_zqb_lfh_ydrh_list a
set a.grid_subst_name=b.aliasname 
from bssdev.dim_subst b
where a.grid_subst_id=b.subst_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新划小局向：'|| @@ROWCOUNT || ' 条' type info to client;
--放号局向
update tb_zqb_lfh_ydrh_list a
set a.subst_name=b.aliasname 
from bssdev.dim_subst b
where a.subst_id=b.subst_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新放号局向：'|| @@ROWCOUNT || ' 条' type info to client;
--落地营服中心
update tb_zqb_lfh_ydrh_list a
set a.branch_name=b.branch_name
from bssdev.dim_branch b
where a.branch_id=b.branch_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新落地营服中心：'|| @@ROWCOUNT || ' 条' type info to client;
--客户局向
update tb_zqb_lfh_ydrh_list a
set a.subst_name_kh=b.aliasname 
from bssdev.dim_subst_kh b
where a.subst_id_kh=b.org_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新客户局向：'|| @@ROWCOUNT || ' 条' type info to client;
--是否有效
update tb_zqb_lfh_ydrh_list a
set a.is_yx = '否'
;commit;
update tb_zqb_lfh_ydrh_list a
set a.is_yx = '是'
from rptdev.RPT_DAILY_CDMA_DDS_LIST_YD_YX_DAY b 
where b.month_id = @month_id
and a.serv_id = b.serv_id
and b.is_yx=1
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新在网是否有效（日口径）：'|| @@ROWCOUNT || ' 条' type info to client;
--是否乐享主卡/是否5G套餐/是否合约
update tb_zqb_lfh_ydrh_list a
set a.is_lx = (case when b.is_lx = 1 then '是' else '否' end),
a.is_hy = b.is_contract,
a.is_5G = (case when b.is_5g_disc = 1 then '是' else '否' end)
from rptdev.rpt_daily_cdma_dds_list_prodtype_union b
where b.month_id = @month_id
and a.serv_id = b.serv_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新是否乐享主卡/是否5G套餐/是否合约：'|| @@ROWCOUNT || ' 条' type info to client;
--是否携号转入
update tb_zqb_lfh_ydrh_list a
set a.is_xr = '否';
commit;
update tb_zqb_lfh_ydrh_list a
set a.is_xr = '是'
from bssdev.RPT_COMM_CM_PROD_ATTR b
where b.attr_id = 500032046 
AND b.attr_value1 in ('001','002')
and convert(date,b.attr_create_date)>='20191110'
and a.serv_id=b.serv_id
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新是否携号转入：'|| @@ROWCOUNT || ' 条' type info to client;
--政企团购登记信息
update tb_zqb_lfh_ydrh_list a
set a.zqtg_type = b.PARAM_VALUE
from bssdev.rpt_comm_cm_msparam b
where a.serv_id = b.serv_id
and b.PARAM_CODE='SZX20191022' 
and b.prod_offer_id in (500051100,500051102,500051104)
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新政企团购登记信息：'|| @@ROWCOUNT || ' 条' type info to client;
--是否目标客户
update tb_zqb_lfh_ydrh_list
set is_mb='否'
;commit;
update tb_zqb_lfh_ydrh_list  a
set a.is_mb = '是'
from bssdev.tb_mo_custgrp_cust b,dim_acc_nbr_gz5 c
where a.cust_id = b.cust_id
and b.custgrp_code=c.cust_code
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新是否目标客户(cust_code)：'|| @@ROWCOUNT || ' 条' type info to client;
update tb_zqb_lfh_ydrh_list  a
set a.is_mb = '是'
from dim_acc_nbr_gz5 b
where a.is_mb = '否'
and a.vpn_cust_code=b.cust_code
;commit;
message Dateformat(now(),'yyyymmdd hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-更新是否目标客户(vpn_value)：'|| @@ROWCOUNT || ' 条' type info to client;
end if;
message dateformat(now(),'yyyymmdd:hh:nn:ss') || ' 生产月份'||@month_id|| '融升3.0营销发展日清单-基础标签生产完成：'type info to client;
------------------------------------------------------------试图推送---------------------------------------------------
if @is_run_flag1<=2 and @is_run_flag2>=2 then 
message dateformat(now(),'yyyymmdd:hh:nn:ss')|| ' 融升3.0营销发展日清单-试图推送开始：'type info to client;
/*
--表头
drop table if exists vbtb_zqb_lfh_ydrh_list_ColName
;commit;
create table vbtb_zqb_lfh_ydrh_list_ColName
(
a01 varchar(30),
a02 varchar(30),
a03 varchar(30),
a04 varchar(30),
a05 varchar(30),
a06 varchar(30),
a07 varchar(30),
a08 varchar(30),
a09 varchar(30),
a10 varchar(30),
a11 varchar(30),
a12 varchar(30),
a13 varchar(30),
a14 varchar(30),
a15 varchar(30),
a16 varchar(30),
a17 varchar(30),
a18 varchar(30),
a19 varchar(30),
a20 varchar(30),
a21 varchar(30),
a22 varchar(30),
a23 varchar(30),
a24 varchar(30),
a25 varchar(30),
a26 varchar(30),
a27 varchar(30),
a28 varchar(30),
a29 varchar(30),
a30 varchar(30)
);commit;
insert into vbtb_zqb_lfh_ydrh_list_ColName values('接入号','客户名称','统计日期','放号局向','划小局向','客户局向','落地营服中心','入网类型（新入网/存量续约）','揽装人工号','揽装人名称'
,'揽装人局向','082标识受理时间','082标识竣工时间','号码入网时间','入网时办理的语音套餐','服务分群','VPN群号','VPN群对应群名','渠道大类','渠道小类','政企客户类型','同产权专线数量'
,'同产权专线上月收入','是否乐享主卡','是否有效入网','是否合约','是否携入','是否5G套餐','政企团购登记信息','是否目标客户')
;commit;
message dateformat(now(),'yyyymmdd:hh:nn:ss')|| ' 融升3.0营销发展日清单-表头生产结束：' || @@ROWCOUNT || ' 条' type info to client;
*/
--试图
set @sql1='
drop view if exists vbtb_zqb_lfh_ydrh_list;
commit;
create view vbtb_zqb_lfh_ydrh_list as
select acc_nbr,cust_name,sum_date,subst_name,grid_subst_name,subst_name_kh,branch_name,rw_type,salestaff_id,salestaff_name,sales_subst_name,act_date,subs_stat_date,create_date
,cdma_disc_name,case when serv_grp_type=''01'' then ''政企'' else ''公众'' end as zq_type,vpn_value,vpn_cust_name,channel_type_2011,channel_subtype_2011,cust_type,cnt_zx,fee_zx
,is_lx,is_yx,is_hy,is_xr,is_5G,zqtg_type,is_mb
from tb_zqb_lfh_ydrh_list
;commit;
';execute(@sql1);
commit;
message dateformat(now(),'yyyymmdd:hh:nn:ss')|| ' 融升3.0营销发展日清单--试图生产结束：'type info to client;
end if;
grant select on vbtb_zqb_lfh_ydrh_list to public;
message dateformat(now(),'yyyymmdd:hh:nn:ss')|| ' 融升3.0营销发展日清单--程序生产结束：' type info to client;
end