/*

==============================================================================
stored Procedure:load silver layer (Bronze---> Silver)
=================================================================
Script Descraption:
	  1_	This stored Procedure performs the ETL(Extract--> Transform--> Load) prosses to
		2_'Silver' Schema Tables from the 'Bronze' Schema.
	    3_Truncates table in Silver Schema
		  4_Inserts Transformed and Cleansed Data from Bronze into Silver Tablesa
===============================================================================
*/
create or Alter Procedure Silver.Load_Silver
as
Begin 
  Begin Try
	Declare @Start_Time datetime,@End_Time Datetime,@Start_Batch Datetime,@End_Batch Datetime 

	set @Start_Batch = getdate();
	print'========================================='
	print'Loading Silver Layer'
	print'========================================='

	print'========================================='
	print'Loading Crm Tables'
	print'========================================='
	---------------------------------------------------
	/*1_clean silver.crm_cust_info */
	-----------------------------------------------------
	Set @Start_Time = GETDATE();
	insert into silver.crm_cust_info
	(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
	select 
	cst_id,
	cst_key,
	 trim (cst_firstname) as cst_firstname,
	 trim(cst_lastname) as cst_lastname,
	case when upper(trim(cst_marital_status))='s' then 'Single'
	when upper(trim(cst_marital_status)) ='m' then 'married'
	else 'N/A'
	end cst_marital_status,

	  case when   upper ( trim (cst_gndr)) ='f' then 'female'
		   when    upper ( trim (cst_gndr)) ='m' then 'male'
		  else 'N/A'
		  end cst_gndr,
		  cst_create_date

	from(
	select*,
	Row_number() over (partition by cst_id order by cst_create_date desc) as flag_last

	from bronze.crm_cust_info 
	) t where flag_last =1 

	Set @End_Time = GETDATE();
	print'>>>Load Diuration Time' + Cast (datediff(Second,@Start_Time,@End_Time) as nvarchar) + 'Sec'
	-------------------------------------------------------------------------------------

	-----------------------------------------
	/*2_clean silver.prod_cust_info */
	------------------------------------------
	Set @Start_Time = GETDATE();

	insert into silver.crm_prod_info
	(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt	
	)
	select 
	prd_id,
	 Replace(substring (prd_key,1,5),'-','_') as cat_ID,
	 substring(prd_key,7,len(prd_key)) as prd_key,
	prd_nm,
	isnull(prd_cost,0) as prd_cost,

	case upper(trim(prd_line))
	when 'M' then 'Mountain'
	when 'R' then 'Rod'
	when 'S' then 'other sales'
	when 'T' then 'other Sales'
	else 'N/A'
	End prd_line,
	 cast (prd_start_dt as date) as prd_start_dt,
	 cast (lead(prd_start_dt) over (partition by prd_key order by prd_start_dt )-1 as date) as prd_end_dt

	   from bronze.crm_prod_info  p

	Set @End_Time = GETDATE();
	print'>>>Load Diuration Time' + Cast (datediff(Second,@Start_Time,@End_Time) as nvarchar) + 'Sec'
	------------------------------------------------------------------------

	-----------------------------------------
	/*3_clean silver.prod_cust_info */
	------------------------------------------
	Set @Start_Time = GETDATE();


	insert into silver.crm_Sls_info
	(
		sls_ord_num , 
		sls_cust_id,
		sls_prd_key, 
		sls_order_dt, 
		sls_ship_dt ,
		sls_due_dt ,
		sls_sales ,
		sls_price,
		sls_quantity
	)
	select
	sls_ord_num,
	sls_cust_id,
	sls_prd_key,
	case when sls_order_dt =0 or len(sls_order_dt) !=8 then null
	else cast(cast (sls_order_dt as varchar) as date)
	end as sls_order_dt,
	case when sls_due_dt =0 or len(sls_due_dt )!=8 then null
	else  cast(cast( sls_due_dt as varchar) as date)
	end as sls_due_dt,
	case when sls_ship_dt =0 or len(sls_ship_dt )!=8 then null
	else  cast(cast( sls_ship_dt as varchar) as date)
	end as sls_ship_dt,
	-------------------------------------------------------------

	case when sls_sales is null or sls_sales <= 0 or sls_sales != abs(sls_price) * abs(sls_quantity) 
	then abs(sls_price) * abs(sls_quantity)
	else sls_sales
	end as sls_sales,

	case when sls_price is null or sls_price <=0  
	then sls_sales /nullif(sls_quantity,0)
	else sls_price
	end as sls_price,
	sls_quantity
	from bronze.crm_Sls_info 


	Set @End_Time = GETDATE();
	print'>>>Load Diuration Time' + Cast (datediff(Second,@Start_Time,@End_Time) as nvarchar) + 'Sec'
	   print '>> -------------';
	print'========================================='
	print'Loading ERP Tables'
	print'========================================='
	-------------------------------
	/*4_clean_silver.erp_cust_info*/
	---------------------------------
	Set @Start_Time = GETDATE();

	insert into silver.erp_cust_info
	(CID,
	BDATE,
	GEN)
	select 	
		Case when CID like 'NAS%' then Substring(CID,4,len(CID))
		else CID
		end as CID,

		case 
		when BDATE > GETDATE() then null
		 else BDATE
		 end as BDATE,
		 CASE 
		 when UPPER(TRIM(GEN)) in ('F','Female') THEN 'Female'
		 when UPPER(TRIM(GEN))in ('M','Male') THEN 'Male'
		else 'N/A'
		end  as GEN

	from silver.erp_cust_info;

	Set @End_Time = GETDATE();
	print'>>>Load Diuration Time' + Cast (datediff(Second,@Start_Time,@End_Time) as nvarchar) + 'Sec'
	-----------------------------------------------------

	-------------------------------------------------
	/*5_clean_silver.erp_Loc_info--*/
	-------------------------------------------------
	Set @Start_Time = GETDATE();
	insert into silver.erp_Loc_info
	(
		CID,
		CNTRY
	)
	select 
	Replace(CID,'-','') CID,

	case when trim(CNTRY) = 'DE' then 'Germany'
	when	trim(CNTRY) in ('US','USA') then 'United Kingdom'
	else 'N\a'
	end as CNTRY
	from bronze.erp_Loc_info;

	Set @End_Time = GETDATE();
	print'>>>Load Diuration Time' + Cast (datediff(Second,@Start_Time,@End_Time) as nvarchar) + 'Sec'
	   print '>> -------------';
	---------------------------------------------------------

	----------------------------------------------------
	/*6_clean_silver.erp_Px_CAT_info*/
	---------------------------------------------------
	Set @Start_Time = GETDATE();
	insert into silver.erp_Px_CAT_info
	(ID,
	CAT,
	MAINTENANCE,
	SUBCAT)
	select 
	ID,
	CAT,
	MAINTENANCE,
	SUBCAT
	 from bronze.erp_Px_CAT_info ;
	 --------------------------------------------------------------------------------------
	Set @End_Time = GETDATE();
	print'>>>Load Diuration Time' + Cast (datediff(Second,@Start_Time,@End_Time) as nvarchar) + 'Sec'
	   print '>> ------------------------------------------------------------------------';

		   Set @End_Batch = GETDATE();
	   print'Load Duratiion>>>>' + cast(datediff(Second,@Start_Batch,@End_Batch)as nvarchar) +'Second'
	   print '>> -------------';

  end Try
   Begin Catch
	print'=================================='
	print'Error With Loading Bronze to Selver'
	print'Error Message'+Error_Message();
	print'Error Message' +cast(Error_Number() as Nvarchar);
	print'Error Message'+ Cast(Error_State()as nvarchar);
   end Catch
   
end
