/*
    ============================================
    DDL Script :Create Gold Layer as Views.
    ===========================================
  Script Descrption:
    1- this Script Create Views for Gold Layer in the Datawerehous.
    2- The Gold Layer Final Dimension and Fact Tables (Str Shcema).
    Eact view performs Transformations and combines data from "Selver_Layer"
    the views you can  by Queied Directily for Analysis and Reporting.
*/

-------------------------------1__gold.Dim_Customers--------------------------------------------
if object('gold.Dim_Customers','v') is not null

drop  view 'gold.Dim_Customers';

create view gold.Dim_Customers
as
WITH Ctm AS (
    SELECT 
        ROW_NUMBER() OVER(PARTITION BY ca.CID ORDER BY ci.cst_create_date) AS rn,
         
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_marital_status,
       case when  ci.cst_gndr != 'N/A' then ci.cst_gndr
        else  coalesce(ca.GEN , 'N/A')  
        end as nwe_gnder,
        ci.cst_create_date,
        ca.BDATE,
        lc.CNTRY,
        ca.Age

    FROM Silver.crm_cust_info ci 
    LEFT JOIN silver.erp_cust_info Ca
        ON ci.cst_key = ca.CID 
    LEFT JOIN silver.erp_Loc_info Lc
        ON ci.cst_key = Lc.CID
)
select
     ROW_NUMBER() OVER(ORDER BY cst_id) AS Customer_key, 
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    nwe_gnder, 
    cst_create_date,
    BDATE,
    CNTRY,
    Age
FROM Ctm
WHERE rn = 1
------------------------------------------------------------------------------------------

------------------------------------------------------2__gold.Dim_Products----------------------------------------------------------------------------------
if object('gold.Dim_Products','v') is not null

drop  view 'gold.Dim_Products';

create view gold.Dim_Products 
as
with Cmt 
as
(

Select 
ROW_NUMBER() OVER(PARTITION BY prd_id ORDER BY pn.prd_start_dt) AS rn,
pn.prd_id,
pn.prd_key,
pn.prd_nm,
pn.Cat_id,
pn.prd_cost,
pn.prd_line,
pn.prd_start_dt,
pc.CAT,
pc.SUBCAT,
pc.MAINTENANCE
from silver.crm_prod_info pn
left join silver.erp_Px_CAT_info pc
on  pn.Cat_id= pc.ID
where pn.prd_end_dt  is null-- filter out all historcal data
)
select 
	row_number() over( order by prd_id) as Product_Key,
	prd_id as Product_id, 
	prd_key as Product_Number,
	prd_nm as Product_Name,
	prd_cost as Product_Cost,
	prd_line as Product_Line,
	prd_start_dt,
	Cat_id as Categry_id,
	CAT as Categry,
	SUBCAT as  SUB_Categry,
	MAINTENANCE
from Cmt
where rn =1



------------------------------------------------------3__(gold.Fact_Sales)----------------------------------------------------------------------------------
if object('gold.Fact_Sales','v') is not null

drop  view 'gold.Fact_Sales';

create view gold.Fact_Sales as
select
sls_ord_num,
DC.cst_id,
sls_prd_key,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from silver.crm_Sls_info
left join gold.Dim_Customers DC
on 
sls_cust_id =DC.cst_id
left join gold.Dim_Products 
on 
sls_prd_key = Product_Number
