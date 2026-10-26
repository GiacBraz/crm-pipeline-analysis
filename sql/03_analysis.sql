Q2.1 
--Cycle days of won opportunities: avg and median fo the engaging period. Sales cycle length of Won deals, overall (mean and median, in days)
-- Cycle = close_date - engage_date. Median > mean suggests a block of very fast closings.
select median(datediff('day', engage_date, close_date)) as median_engage_period, 
round(avg(datediff('day', engage_date, close_date)),2) as avg_engage_period from sales_pipeline
where deal_stage in('Won');

Q2.2: Cycle days of won opportunities: number of deals by each bucket. Distribution of Won deals by cycle length (10-day buckets)
-- Convention: bucket_start = 0 means 0-9 days, 10 means 10-19 days, and so on.
-- Used to check the shape of the distribution behind the mean/median gap.
WITH won_deals AS (
    SELECT opportunity_id,
           datediff('day', engage_date, close_date) AS cycle_days
    FROM sales_pipeline
    WHERE deal_stage = 'Won'
),
bucketed AS (
    SELECT cycle_days,
           FLOOR(cycle_days / 10.0) * 10 AS bucket_start
    FROM won_deals
)
SELECT bucket_start,
       COUNT(*) AS n_deals
FROM bucketed
GROUP BY bucket_start
ORDER BY bucket_start;

Q2.3: Sales cycle length (Won deals) by product
with won_deals as (
select product, datediff('day', engage_date, close_date) as cycle_days from sales_pipeline
where deal_stage='Won')
select product, count(*) as n_deals, median(cycle_days) as median_cycle_days, round(avg(cycle_days),2) as avg_cycle_days from won_deals
group by product
order by avg_cycle_days;

Q2.4: Cycle length of Won deals by agent (mean, median, deal count)
with won_deal as (
    select sales_agent,
           datediff('day', engage_date, close_date) as cycle_days
    from sales_pipeline
    where deal_stage = 'Won'
)
select sales_agent,
       round(avg(cycle_days), 2) as avg_cycle_days,
       median(cycle_days) as median_cycle_days,
       count(*) as n_deals
from won_deal
group by sales_agent
order by median_cycle_days;


Q2.5: Smallest and largest number of Won deals per agent
with won_deal as (
    select sales_agent,
           datediff('day', engage_date, close_date) as cycle_days
    from sales_pipeline
    where deal_stage = 'Won'
),
per_agent as (
    select sales_agent,
           median(cycle_days) as median_cycle_days,
           count(*) as n_deals
    from won_deal
    group by sales_agent
)
select min(n_deals) as min_n_deals,
       max(n_deals) as max_n_deals
from per_agent;


Q2.6: Fastest vs slowest agent (by median cycle): deals and median per product, shared products only
with won_deal as (
    select sales_agent,
           datediff('day', engage_date, close_date) as cycle_days,
           product
    from sales_pipeline
    where deal_stage = 'Won'
      and sales_agent in ('Elease Gluck', 'Moses Frase')
      and product not in ('GTK 500', 'GTX Pro')
)
select product,
       count(*) filter (where sales_agent = 'Elease Gluck') as gluck_n,
       count(*) filter (where sales_agent = 'Moses Frase') as frase_n,
       median(cycle_days) filter (where sales_agent = 'Elease Gluck') as gluck_median,
       median(cycle_days) filter (where sales_agent = 'Moses Frase') as frase_median
from won_deal
group by product;