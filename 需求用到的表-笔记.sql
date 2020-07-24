--rptdev是对面数据室通用的账号，bssdev是基础数据生产账号

--用户资料表  bssdev.rpt_comm_cm_serv
serv_id 用户id 
acc_nbr  号码 
serv_nbr  服务号
serv_lev  服务等级
city_village_id  城乡ID
state  状态
user_type 用户类型
user_char  计费属性
payment_type  付费类型
billing_type  租费类型
prod_id 套餐号
exchange_id  测量室 
serv_col2  受理点
address_id  联系人id
is_phs_tk 是否激活 
cust_addr  客户地址
speed_value 宽带速率 
arrear_month  欠缴月份 
arrear_month_last  上月欠缴月份 
payment_id  付费标识
net_connect_type  互联网接入方式
acc_nbr2  互联网账号
cdma_class_id  cdma新老客户
phone_number_id   号段
wireless_type 
vpn_class  vpn类型
cdma_disc_type 主套餐
add_disc_type  加载套餐
serv_grp_type  服务分群
itv_user_type   itv用户类型
create_date  入网时间
subs_date 服务申请时间
open_date 服务开通时间
modi_staff_id  操作工号
ccust_id  直销客户
salestaff_id  揽装人工号
sales_type_id  揽装类型标识
cust_id  产权客户id
cust_name  产权客户名称
cust_nbr  产权客户号码
start_grp_dl  客户大类
start_grp_dl  客户小类
cust_level  产权客户级别
cust_type_id  产权客户类型
cust_class_dl  行业大类
cust_class_zl  行业中类
cust_class_xl  行业小类
social_id  证件
social_id_type  证件类型
subst_id  局向id
branch_id 营服id
bevy_cust_id  网格单元id 
bevy_cust_code  网格单元编码
bevy_cust_name  网格单元名称
grid_subst_id  划小局向 
grid_branch_id  划小营服
grid_id  划小责任田编码
grid_code  划小责任田编码
grid_name  网格责任田名称
grid_cust_manager  划小客户经理
is_cl  是否彩铃
is_lx  是否来电显示
is_tyxsz  是否天翼学生证






--优惠业务订单表  rptdev.rpt_comm_ba_msdisc_union 
subs_id    订单号
subs_code  订单编码 
serv_id    用户id
acc_nbr    用户号码 
user_type  用户类型
user_char  计费属性
payment_type  付费类型
billing_type  租费类型
fee_mode   计费方式
prod_id   产品号
salestaff_id  揽装人工号
sales_type_id  揽装类型标识
staff_id   受理人
modi_staff_id  操作工号
org_id  受理机构标识
exchange_id  测量室
serv_addr_id  标准地址
speed_value  宽带速率
arrear_month   欠缴月份 
arrear_month_last  上月欠缴月份
payment_id  付费标识
net_connect_type  互联网接入方式
acc_nbr2  互联网账号
cdma_class_id  cdma新老客户
phone_number_id   号段
wireless_type 
vpn_class  vpn类型
cdma_disc_type 主套餐
add_disc_type  加载套餐
serv_grp_type  服务分群
create_date  入网时间
subs_stat 订单状态
subs_stat_reason  订单状态原因
subs_stat_date  竣工时间
action_id  业务id    -- 1292-订购   6200-互换  1293-退订  1294-变更
action_type 业务类型
action_ex_type  业务子类型
act_date  受理时间
cust_id  产权客户id
cust_name  产权客户名称
cust_nbr  产权客户号码
subst_id    放号局向  --放号是指号码落地，跟用户受理地址有关系。客户局向主要是客户归属区域关系
subst_id_kh   客户局向
grid_subst_id   划小局向  --划小就是将资源最小细分化，以前最小的维度是网格，现在细分到人
branch_id  营服id
grid_branch_id  划小营服
contacter  联系人
conphone  联系人电话 
fee_id  纳费类型 --先付费 后付费
prod_offer_id  套餐id 
msinfo_id  营销信息id
obj_grp_id  对象组id 
subs_date 服务申请时间
open_date 服务开通时间
address_id  联系人id
is_phs_tk  是否激活
bevy_cust_id  网格单元id 
bevy_cust_code  网格单元编码 
grid_id 划小责任田id
grid_code  划小责任田编码
serv_channel_id  统计渠道
subst_id_kh  客户局向 
branch_id_kh  客户营服
kh_staff_id  客户经理
zx_school  校园
channel_type_2011   渠道大类 
channel_subtype_2011   渠道小类

--局向维表  bssdev.dim_subst  
subst_id  局向id 
subst_name  局向名称
aliasname  正式名称
create_date  创建时间
seq_id  申请单id 

--营服维表 bssdev.dim_branch 
branch_id  营服id
branch_name  营服名称
aliasname  正式名称
create_date  创建时间
seq_id  申请单id 
is_zq  是否政企
subst_id  局向id

--优惠资料表  rpt_comm_cm_subs



