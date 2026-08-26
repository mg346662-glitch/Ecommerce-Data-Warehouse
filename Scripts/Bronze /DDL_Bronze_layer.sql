/*
	===================================
	DDl Script: create Bronze Tables
	===================================
	Script Description :
		1 - This Script Create  Tables in "Bronze" Shcema ,Dropping Existing Tables
		     if Alreard Exsit.
		2 - using Function  "IF object ()" to Dropping the Table if Alreard Exsit.
		3 _ Run this Script  to re_Define the DDl Structuer of "Bronze" Table.
*/




---------------------create bronze.crm_cust_info----------------------

if OBject_id('bronze.crm_cust_info','u') is not null
drop table bronze.crm_cust_info;

create table bronze.crm_cust_info
(
cst_id int, 
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
);
---------------------create bronze.crm_prod_info----------------------
if OBject_id('bronze.crm_prod_info','u') is not null
drop table bronze.crm_prod_info;
create table bronze.crm_prod_info
(
prd_id int, 
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime
);

---------------------create bronze.crm_Sls_info----------------------

if OBject_id('bronze.crm_Sls_info','u') is not null
drop table bronze.crm_Sls_info;

create table bronze.crm_Sls_info
(
sls_ord_num nvarchar(50), 
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int 
);
---------------------create bronze.erp_cust_info----------------------

if OBject_id('bronze.erp_cust_info','u') is not null
drop table bronze.erp_cust_info;

create table bronze.erp_cust_info  
(
CID nvarchar (50), 
BDATE date,
GEN nvarchar (50),
);

---------------------create bronze.erp_Loc_info----------------------

if OBject_id('bronze.erp_Loc_info','u') is not null
drop table bronze.erp_Loc_info;

create table bronze.erp_Loc_info  
(
CID	nvarchar (50), 
CNTRY nvarchar (50)
);

---------------------create bronze.erp_Px_CAT_info----------------------

if OBject_id('bronze.erp_Px_CAT_info','u') is not null
drop table bronze.erp_Px_CAT_info;

create table bronze.erp_Px_CAT_info  
(
ID	nvarchar (50), 
CAT nvarchar (50),
SUBCAT nvarchar (50),
MAINTENANCE nvarchar (50)
);
