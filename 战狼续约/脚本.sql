---
drop table if exists kk_temp;commit;
select distinct cust_nbr,acc_nbr,serv_id,prod_offer_code into kk_temp
from rptdev.RPT_COMM_CM_MSDISC_union a, bssdev.OFFER b
where a.prod_offer_id=b.offer_id
and prod_offer_code in ('YD4G01-096-1-1','YD4G01-096-1-2','YD4G01-088-1-1','YD4G01-056-1-1','YD4G01-088-1-2')
and a.month_id=202007
;commit;

alter table kk_temp add (dj_prod_offer_code varchar(256) null,xl int null);commit;

update kk_temp a 
 set a.dj_prod_offer_code='29元团购（5G降速）',
     xl=1
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-096-1-1'
and c.prod_offer_code='TG0003-002-1-3'
and b.limit_date>='20200801'
and b.month_id=202007
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='39元团购（10G降速）',
     xl=2
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-096-1-2'
and c.prod_offer_code='TG0003-002-1-2'
and b.limit_date>='20200801'
and b.month_id=202007
;commit;


update kk_temp a 
 set a.dj_prod_offer_code='49团购',
     xl=3
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-1'
and c.prod_offer_code in ('YD4G03-222-1-4')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='59团购',
     xl=4
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-1'
and c.prod_offer_code in ('YD4G03-222-1-3')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;


update kk_temp a 
 set a.dj_prod_offer_code='69团购',
     xl=5
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-1'
and c.prod_offer_code in ('YD4G03-222-1-2')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='79团购',
     xl=6
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-1'
and c.prod_offer_code in ('YD4G03-222-1-1')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='49元团购（赠金直降版）',
     xl=7
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-1'
and c.prod_offer_code in ('TG0003-001-1-1')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

---
drop table if exists #kk_temp0;commit;
select b.offer_name,a.param_value,c.serv_id into #kk_temp0 from bssdev.rpt_comm_cm_msparam a
,bssdev.offer b,kk_temp c 
where a.prod_offer_id=b.offer_id
and b.prod_offer_code='YD0203-082'
and a.param_code='991100000725'
and c.prod_offer_code='YD4G01-088-1-1'
and a.serv_id=c.serv_id
and a.limit_date>='20200801' 
;commit;
update kk_temp a ----zengjin
 set a.dj_prod_offer_code=
     case when b.param_value='1920'then'19元大战狼'
          when b.param_value='1680'then'29元大战狼'end
from #kk_temp0 b
where a.serv_id=b.serv_id

update kk_temp a ----zengjin
 set a.xl=
     case when dj_prod_offer_code='19元大战狼'then 9
          when dj_prod_offer_code='29元大战狼'then 8 end
from #kk_temp0 b
where a.serv_id=b.serv_id




update kk_temp a 
 set a.dj_prod_offer_code='79元团购',
     xl=10
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-056-1-1'
and c.prod_offer_code in ('YD4G03-181-1-1')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='69元团购',
     xl=11
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-056-1-1'
and c.prod_offer_code in ('YD4G03-181-1-2')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='59元团购',
     xl=12
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-056-1-1'
and c.prod_offer_code in ('YD4G03-181-1-3')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='49元团购',
     xl=13
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-056-1-1'
and c.prod_offer_code in ('YD4G03-181-1-4')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='199五折',
     xl=14
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-2'
and c.prod_offer_code in ('YD0203-476-1-1')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='199六折',
     xl=15
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-2'
and c.prod_offer_code in ('YD0203-476-1-2')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='199七折',
     xl=16
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-2'
and c.prod_offer_code in ('YD0203-476-1-3')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

update kk_temp a 
 set a.dj_prod_offer_code='199八折',
     xl=17
from rptdev.RPT_COMM_CM_MSDISC_union b, bssdev.OFFER c
where b.prod_offer_id=c.offer_id
and a.serv_id=b.serv_id
and a.prod_offer_code='YD4G01-088-1-2'
and c.prod_offer_code in ('YD0203-476-1-4')
and b.month_id=202007
and b.limit_date>='20200801'
;commit;

drop table if exists kk_temp2;commit;
select a.* ,cust_name into kk_temp2
from kk_temp a,bssdev.customer b 
where a.cust_nbr=b.cust_number
and dj_prod_offer_code is not null
;commit;

alter table kk_temp2 add is_gsm int default 0 null;commit;
update kk_temp2 a 
 set is_gsm=1 
where length(cust_name)>4
;commit;


select xl,dj_prod_offer_code,prod_offer_code,count(distinct case when is_gsm=0 then serv_id end),count(distinct case when is_gsm=1 then serv_id end)
 from  kk_temp2 group by  xl,dj_prod_offer_code,prod_offer_code