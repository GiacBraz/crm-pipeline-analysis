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

--found 5 agents with no deals in the sales_pipeline. Put the manager and region in the table as well
select st.sales_agent, manager, regional_office
from sales_teams st left join sales_pipeline sp on sp.sales_agent=st.sales_agent
where sp.sales_agent is null;

-- Check 4: uniqueness of keys. Expected: 0 rows (no key appears more than once).
-- sales_pipeline: opportunity_id; accounts: account; products: product; sales_teams: sales_agent. No duplicates
select count(distinct (opportunity_id)) as opport_id_distinti, count(*) as righe from sales_pipeline;
select count(distinct (product)) as product_distinti, count(*) as righe from products;
select count(distinct (account)) as account_distinti, count(*) as righe from accounts;
select count(distinct (sales_agent)) as agents_distinti, count(*) as righe from sales_teams;