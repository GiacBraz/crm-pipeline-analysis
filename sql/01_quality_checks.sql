--controllo che il prodotto 'GTXPro' di zero righe dopo la modifica
select sp.product, count(*)
from sales_pipeline sp left join products p on sp.product=p.product
where p.product  is null
group by sp.product;

--checking on account field in sales_pipeline and accounts tables. Only the closed opportunity have an account assigned. In sales_pipelin all the others are NULL on the account field. This is the query tu use to check
select sp.account, count(*)
from sales_pipeline sp left join accounts a on sp.account=a.account
where a.account is null
group by sp.account;
--this is the query to see the #of opportunities by deal stage, where the NULL are.
select deal_stage, account, count(opportunity_id) from sales_pipeline
where account is null
group by deal_stage, account;
