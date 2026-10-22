--creo in DuckDB nel database le 4 tabelle utilizzando i dati presenti nei 4 csv.
create or replace table accounts as 
select * from read_csv('data/accounts.csv');
create or replace table products as 
select * from read_csv('data/products.csv');
create or replace table sales_pipeline as 
select * from read_csv('data/sales_pipeline.csv');
create or replace table sales_teams as 
select * from read_csv('data/sales_teams.csv');
