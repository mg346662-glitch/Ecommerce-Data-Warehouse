/*
--------------------------------
Create the new DataWereHouse to Sales_Data
---------------------------------
1_ script Create the new DataWereHouse to Sales_Data
  and Checking if this already Eaxists.
  within the database, it is droped and Recreated
  ------------------------------------------------------
2_ create the three schemas ("Pronze","Silver","Gold")

 

*/-----------------------------------------------------------------------

use master



--drop and recreate "DataWerehouse_1"

if exists(Select 1 from sys.databases where name = "DataWerehouse_1" )
begin
Alter Database DataWerehouse_1 set singl_user with rollback immediate;
drop database DataWerehouse_1
end

go

--create_DataWerehouse-----

create Database DataWerehouse_1;
use DataWerehouse_1


--cerat the Schemas _larys on SQl ---------

create schema bronze;

go
create schema silver;

go
create schema Gold ;
