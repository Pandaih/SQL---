--直销客户信息
select b.aliasname,branch_org,* from bssdev.ecust_gz_mo_ccust a,bssdev.dim_subst b where ccust_name like '%广东拼播播新媒体有限公司%' 
and a.branch_org=b.subst_id

--直销客户经理关系
select staff_id,staff_name,* from bssdev.grid_gz_ccust_rule where ccust_name like '%广东拼播播新媒体有限公司%'

--局向维表
select * from bssdev.dim_subst

--根据客户经理名称查询局向
select * from bssdev.staff where staff_name='李红梅'

--根据公司名（产权名）
select * from bssdev.customer where cust_name like '%思道%'