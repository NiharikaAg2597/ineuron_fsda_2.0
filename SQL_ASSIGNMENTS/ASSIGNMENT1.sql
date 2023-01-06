
                                                       ASSIGNMENT -1


--1. Load the given dataset into snowflake with a primary key to Order Date column.

USE DEMO_DATABASE;

CREATE OR REPLACE TABLE  NK_SALES_ASSIGNMENT
(
  order_id VARCHAR(20),
  order_date date primary key,
  ship_date date,
  ship_mode VARCHAR(20),
  customer_name VARCHAR(25),
  segment VARCHAR(15),
  country VARCHAR(50),
  market VARCHAR(10),
  region VARCHAR(15),
  product_id VARCHAR(20),
  category VARCHAR(30),
  sub_category VARCHAR(30),
  product_name string,
  sales int,
  quantity NUMBER(6,2),
  discount NUMBER(6,2),
  profit number(6,2),
  shipping_cost NUMBER(10,4),
  order_priority VARCHAR(10),
  year varchar(4)  
);

SELECT * FROM NK_SALES_ASSIGNMENT;


---Field delimiter resolution.

create or replace file format my_csv_format
  type = csv
  record_delimiter = '\n'
  field_delimiter = ','
  skip_header = 1
  null_if = ('NULL', 'null')
  empty_field_as_null = true
  FIELD_OPTIONALLY_ENCLOSED_BY = '0x22';
  
  *********************************************************************************************
  
  --- 2. Change the Primary key to Order Id Column.
  
  alter table NK_SALES_ASSIGNMENT
  drop primary key;
  
  alter table NK_SALES_ASSIGNMENT
  add primary key (order_id);
  
  select 
  year(order_date) as year_only
  from NK_SALES_ASSIGNMENT;

--*********************************************************************************************-----
  
  --- 3. CHECK THE ORDER DATE AND SHIP DATE TYPE AND THINK IN WHICH DATA TYPE YOU HAVE TO CHANGE.
  
  /*
     
      ORDER_DATE     DATE
      SHIP_DATE      DATE
      
      DATE TYPE IS OF DATE TYPE FORMAT ( YYYY-MM-DD)  SO NO CHANGES REQUIRED.
	  ALL THE DATA CLEANING IS DONE VIA MS-EXCEL
  */
  
  ---***************************************************************************************---
  
  
--4. EXTRACT THE LAST NUMBER AFTER THE - AND CREATE OTHER COLUMN AND UPDATE IT.
  
  --(a)  Using split_part() function:

--Step 1: Adding the coloumn to existing table.
alter table NK_SALES_ASSIGNMENT
add extracted_id  integer;

 --step 2: updating the table by adding the required data in that coloumn
update  NK_SALES_ASSIGNMENT
set extracted_id = split_part(order_id,'-',3) ;
  

   
      --(b)Using Substring functon:

  --Step 1: Adding the coloumn to existing table.
 alter table NK_SALES_ASSIGNMENT
add extracted_id_alt integer;

 --step 2: updating the table by adding the required data in that coloumn
update NK_SALES_ASSIGNMENT
SET extracted_id_alt = substr(order_id,9,len(order_id));



--******************************************************************************************----

/*
---5.Create a new column called Discount Flag and categorize it based on discount.
--Use ‘Yes’ if the discount is greater than zero else ‘No’.
*/

--step 1. Adding coloumn Discount_Flag to existing table.
alter table NK_SALES_ASSIGNMENT
add Discount_Flag varchar(20);

--step 2. categorizing it on the basis of discount coloumn using case statement and updating it to newly created coloumn
update NK_SALES_ASSIGNMENT
set Discount_Flag = (case
when discount > 0 then 'YES'
else 'FALSE'
END 
);

---**************************************************************************************----

/*
6. Create a new column called process days and calculate how many days it takes
for each order id to process from the order to its shipment.
*/

--STEP 1.  Adding the PROCESS_DAYS column to the existing table.
ALTER TABLE NK_SALES_ASSIGNMENT
ADD PROCESS_DAYS INTEGER;

--STEP 2. Calculating how many days it takes for each order id to process from the order to its shipment.

select  datediff('day',order_date,ship_date) as DAYS_TAKEN
FROM NK_SALES_ASSIGNMENT;

--STEP 3.  Updating the coloumn with  calculated data.

UPDATE NK_SALES_ASSIGNMENT
SET PROCESS_DAYS = ( DATEDIFF('DAY',ORDER_DATE,SHIP_DATE));


---******************************************************************************************************--

/*
7.
Create a new column called Rating and then based on the Process dates give
rating like given below.
a. If process days less than or equal to 3days then rating should be 5
b. If process days are greater than 3 and less than or equal to 6 then rating
should be 4
c. If process days are greater than 6 and less than or equal to 10 then rating
should be 3
d. If process days are greater than 10 then the rating should be 2.
*/

--Step 1 : Adding the RATING column to the existing table.
ALTER TABLE NK_SALES_ASSIGNMENT
ADD RATING INTEGER;


--Step 2: Based on the condition calculated the ratings
select process_days, order_id,
case
when process_days <=3 then '5'
when process_days between 4 and 6 then '4'
when process_days between 7 and 10 then '3'
else 2
end as rating 
from NK_SALES_ASSIGNMENT;


--Step: 3 updating the table and used the case statement for rating analysis.
update NK_SALES_ASSIGNMENT
set RATING = case
when process_days <=3 then '5'
when process_days between 4 and 6 then '4'
when process_days between 7 and 10 then '3'
else 2
end;

