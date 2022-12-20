---------------------CASE STATEMENT--------------------------------

USE "DEMO_DATABASE";
 
SELECT * FROM "DEMO_DATABASE"."PUBLIC"."NK_CONSUMER_COMPLAINTS";

/*
  Q.Using case statement classify submitted_via :
  i> classify it as Outbound whereever submitted_via is 'Phone','Web'.
  ii>classify it as Inbound whereever submitted_via is 'Email','Postal mail','Referral' .
  iii> Rest  should be classified as 'Electronics'.
  iv>coloumn name should be Submission_Type
*/

select submitted_via, SUB_PRODUCT,PRODUCT_NAME,COMPANY,
case
when submitted_via in ('Phone','Web') then 'Outbound'
when submitted_via in ('Email','Postal mail','Referral') then 'Inbound'
else 'Electronics'
End as Submission_Type
from NK_CONSUMER_COMPLAINTS;


-----------------------------------------------------------------------------------------------


SELECT distinct product_name FROM "DEMO_DATABASE"."PUBLIC"."NK_CONSUMER_COMPLAINTS";

----------------------------------------------------------------------------------------------------

/*Q. using case statement specify the types of product name in PRODUCT_CLASSIFICATION
 table.If product_name is ('Consumer Loan','Student loan','Payday loan')
 then it is LOAN type and  if product_name is('Bank account or service','Mortgage','Debt collection','Credit card','Credit reporting','Money transfers')
 then it is SERVICES type. Else show the original product_name.
*/

select DATE_RECEIVED ,PRODUCT_NAME,
case
when product_name in ('Consumer Loan','Student loan','Payday loan') then 'LOAN'
when product_name in ('Bank account or service','Mortgage','Debt collection','Credit card','Credit reporting','Money transfers') then 'SERVICES'
else product_name
End as Product_Classification,SUB_PRODUCT
from "DEMO_DATABASE"."PUBLIC"."NK_CONSUMER_COMPLAINTS";

--ALTERNATIVE--

select DATE_RECEIVED ,PRODUCT_NAME,
case
when product_name like '%Loan' Or  product_name like'%loan' then 'LOAN'
when product_name in ('Bank account or service','Mortgage','Debt collection','Credit card','Credit reporting','Money transfers') then 'SERVICES'
else product_name
End as Product_Classification,SUB_PRODUCT
from "DEMO_DATABASE"."PUBLIC"."NK_CONSUMER_COMPLAINTS";

--ALTERNATIVE--

SELECT DATE_RECEIVED ,PRODUCT_NAME,
CASE
WHEN UPPER(PRODUCT_NAME) LIKE '%LOAN' THEN 'LOAN-DEPT'
WHEN PRODUCT_NAME IN ('Bank account or service','Mortgage','Debt collection','Credit card',
                      'Credit reporting','Money transfers') THEN 'SERVICES'
ELSE 'OTHER'
END AS PROD_CLASS
FROM "NK_CONSUMER_COMPLAINTS";

------------------------------------------------------------------------------------------------------------------

SELECT distinct  SUB_PRODUCT FROM "DEMO_DATABASE"."PUBLIC"."NK_CONSUMER_COMPLAINTS";


/*

Q. Using case statement implement the condition :   
 i> classify it as loan whereever sub_product name contains loan in it.
 ii>classify it as CARD wherever sub_product name contains card in it.
 iii>classify it as NA wherever sub_product name is 'I do not know' and 'Null'.
 iv>classify it as mortgage wherever sub_product name contain mortgage in it.
 v> Rest of all should be classified as it is.
 vi> Coloumn name : sub_prod_class.
 
 */
 
 select *,
 case
 when Lower(sub_product) like '%loan' then  'loan'
 when lower(sub_product) like '%card' then  'CARD'
 when sub_product ='I do not know' or sub_product is NULL then 'NA'
 when Lower(sub_product) like '%mortgage' or  Lower(sub_product) like '%mortgage%' then 'mortgage'
 else sub_product
 end as sub_prod_class
 from "NK_CONSUMER_COMPLAINTS";

---Alternate-----

select distinct sub_product,
 case
 when Lower(sub_product) like '%loan' then  'loan'
 when lower(sub_product) like '%card' then  'CARD'
  when sub_product ='I do not know' or sub_product is NULL then 'NA'
 when Lower(sub_product) like '%mortgage' or  Lower(sub_product) like '%mortgage%' then 'mortgage'
 else sub_product
 end as sub_prod_class
 from "NK_CONSUMER_COMPLAINTS";

--------------------------------------------------------------------------------------------------------------------

SELECT distinct COMPANY_RESPONSE_TO_CONSUMER FROM "DEMO_DATABASE"."PUBLIC"."NK_CONSUMER_COMPLAINTS";

/*

Q. Using case statement implement the condition :   
 i> classify it as 'Explained' whereever company_response_to_customer is Closed with explanation.
 ii>classify it as 'Monetary Relief Provided' wherever  company_response_to_customer is Closed with monetary relief.
 iii>classify it as 'closed' wherever  company_response_to_customer is Closed or Closed with non-monetary relief.
 iv> Rest of all should be classified as it is.
 v> Coloumn name : cust_res.
  */
 

select  distinct COMPANY_RESPONSE_TO_CONSUMER,
case
when COMPANY_RESPONSE_TO_CONSUMER ='Closed with explanation' then 'Explained'
when COMPANY_RESPONSE_TO_CONSUMER ='Closed with monetary relief' then 'Monetary Relief Provided'
when COMPANY_RESPONSE_TO_CONSUMER = 'Closed'  or COMPANY_RESPONSE_TO_CONSUMER = 'Closed with non-monetary relief' then 'closed'
else COMPANY_RESPONSE_TO_CONSUMER
end as  cust_res
from "NK_CONSUMER_COMPLAINTS";

-----------------------------------------------------------------------------------------------------------------------------

/*
Q. Creating a view and merging all the case statements table into one.
*/


create or replace view Case_Merged as 
select DATE_RECEIVED, 

PRODUCT_NAME,
CASE
WHEN UPPER(PRODUCT_NAME) LIKE '%LOAN' THEN 'LOAN-DEPT'
WHEN PRODUCT_NAME IN ('Bank account or service','Mortgage','Debt collection','Credit card',
                      'Credit reporting','Money transfers') THEN 'SERVICES'
ELSE 'OTHER'
END AS PROD_CLASS,

SUB_PRODUCT,
case
 when Lower(sub_product) like '%loan' then  'loan'
 when lower(sub_product) like '%card' then  'CARD'
  when sub_product ='I do not know' or sub_product is NULL then 'NA'
 when Lower(sub_product) like '%mortgage' or  Lower(sub_product) like '%mortgage%' then 'mortgage'
 else sub_product
 end as sub_prod_class,
 
 COMPANY_RESPONSE_TO_CONSUMER,
case
when COMPANY_RESPONSE_TO_CONSUMER ='Closed with explanation' then 'Explained'
when COMPANY_RESPONSE_TO_CONSUMER ='Closed with monetary relief' then 'Monetary Relief Provided'
when COMPANY_RESPONSE_TO_CONSUMER = 'Closed'  or COMPANY_RESPONSE_TO_CONSUMER = 'Closed with non-monetary relief' then 'closed'
else COMPANY_RESPONSE_TO_CONSUMER
end as  cust_res,

submitted_via,
case
when submitted_via in ('Phone','Web') then 'Outbound'
when submitted_via in ('Email','Postal mail','Referral') then 'Inbound'
else 'Electronics'
End as Submission_Type

from NK_CONSUMER_COMPLAINTS;


---Viewing the merged  (Case_Merged) view.

select * from Case_Merged;



