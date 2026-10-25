--creo in DuckDB nel database le 4 tabelle utilizzando i dati presenti nei 4 csv.
create or replace table accounts as 
select * from read_csv('data/accounts.csv');
create or replace table products as 
select * from read_csv('data/products.csv');
-- Fix: 'GTXPro' in the pipeline is aligned to 'GTX Pro' in products (see docs/data_quality_log.md)
create or replace table sales_pipeline as 
select * replace (case when product = 'GTXPro' then 'GTX Pro' else product end as product) from read_csv('data/sales_pipeline.csv');
create or replace table sales_teams as 
select * from read_csv('data/sales_teams.csv');
