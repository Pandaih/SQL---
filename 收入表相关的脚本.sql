
select * from  zwfxdev.tb_comm_serv_fee  where acc_nbr='ADSLS2531290838'


select  sum(charge)/100,due_income_code from zwfxdev.f_sure_data_list_now where acc_nbr='ADSLS2531290838' group by due_income_code 

select * from dim_due_income_new where due_income_code='SR2011030101040102'

--,'SR2011030101030103','SR2011030101040102'



dim_due_income_new  -- 收入确认维表
zwfxdev.tb_comm_serv_fee -- 出账表 

zwfxdev.f_sure_data_list_now  --后付费
zwfxdev.f_yff_adsl_union --预付费 

zwfxdev.F_SERV_INCOME_STAT zwfxdev.F_SERV_COST_DAILY_YD
select * from F_SERV_INCOME_STAT2
zwfxdev.F_SERV_INCOME_STAT_NEW
zwfxdev.F_SERV_INCOME_STAT2


select * from dim_due_income_new  -- 收入确认维表
/* 
due_income_code  科目编码  【eg：SR41110103】
due_income_name  科目名称  【eg：政企客户收入】
due_desc   科目描述（也可作为科目名称）
due_type 科目类型【eg：经营收入->政企客户收入->基础业务收入】
*/

select * from zwfxdev.f_sure_data_list_now  --后付费

