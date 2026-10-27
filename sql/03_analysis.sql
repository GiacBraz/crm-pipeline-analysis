--Q2.1 
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

--Q2.3: Sales cycle length (Won deals) by product
with won_deals as (
select product, datediff('day', engage_date, close_date) as cycle_days from sales_pipeline
where deal_stage='Won')
select product, count(*) as n_deals, median(cycle_days) as median_cycle_days, round(avg(cycle_days),2) as avg_cycle_days from won_deals
group by product
order by avg_cycle_days;

--Q2.4: Cycle length of Won deals by agent (mean, median, deal count)
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


--Q2.5: Smallest and largest number of Won deals per agent
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


--Q2.6: Fastest vs slowest agent (by median cycle): deals and median per product, shared products only
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


--Q4.1: Win rate of closed deals by cycle length (10-day buckets, 0 = 0-9 days)
--Used to check whether longer cycles lead to more lost deals.
WITH wonlost_deals AS (
    SELECT opportunity_id,
           datediff('day', engage_date, close_date) AS cycle_days, deal_stage
    FROM sales_pipeline
    WHERE deal_stage in('Won','Lost')
),
bucketed AS (
    SELECT cycle_days, deal_stage,
           FLOOR(cycle_days / 10.0) * 10 AS bucket_start
    FROM wonlost_deals
)
SELECT bucket_start,
       COUNT(*) AS n_deals,
       COUNT(*) FILTER (WHERE deal_stage = 'Won') AS won_n,
       COUNT(*) FILTER (WHERE deal_stage = 'Lost') AS lost_n,
       ROUND(100.0*COUNT(*) FILTER (WHERE deal_stage = 'Won') / COUNT(*),1) as win_rate_pct,
       ROUND(100-ROUND(100.0*COUNT(*) FILTER (WHERE deal_stage = 'Won') / COUNT(*),1),1) as lost_rate_pct
FROM bucketed
GROUP BY bucket_start
ORDER BY bucket_start;

--Q4.2: Stalled open deals by agent, threshold = median cycle of Won deals
--Age = days from engage_date to 2017-12-31. Only Engaging deals (Prospecting has no engage_date).
with threshold as (
select median(datediff('day', engage_date, close_date)) as median_cycle_days from sales_pipeline
where deal_stage='Won'
),
engaging_deals as (
select sales_agent, datediff('day', engage_date, '2017-12-31') as deal_age
from sales_pipeline
where deal_stage in('Engaging')
),
classified as (
select sales_agent, deal_age, median_cycle_days,
case when deal_age > median_cycle_days then 'stalled'
else 'not_stalled' end as status
from engaging_deals
cross join threshold),

stalled_per_agent as (
select sales_agent, 
COUNT(*) FILTER (WHERE status = 'stalled') AS stalled_n,
COUNT(*) as open_deals
from classified
group by sales_agent)

select sales_agent, ROUND(100.0 * stalled_n / open_deals, 1) AS stalled_pct, stalled_n, open_deals
from stalled_per_agent
order by stalled_pct desc;

--Q4.3: Age distribution of Engaging deals (30-day buckets, 0 = 0-29 days)
WITH engag_deals AS (
    SELECT opportunity_id,
           datediff('day', engage_date, '2017-12-31') AS deal_age
    FROM sales_pipeline
    WHERE deal_stage = 'Engaging'
),
bucketed AS (
    SELECT deal_age,
           FLOOR(deal_age / 30.0) * 30 AS bucket_start
    FROM engag_deals
)
SELECT bucket_start,
       COUNT(*) AS n_deals
FROM bucketed
GROUP BY bucket_start
ORDER BY bucket_start;

--Q4.4: Engaging deals older than 138 days (longest closed deal) and older than 200 days
select count(*) as open_deals,
       count(*) filter (where datediff('day', engage_date, '2017-12-31') > 138) as over_138_days,
       count(*) filter (where datediff('day', engage_date, '2017-12-31') > 200) as over_200_days
from sales_pipeline
where deal_stage = 'Engaging';

--Q4.5: Stalled open deals by agent, with a fixed threshold of 200 days, plus region and manager
with threshold as (
select 200 as fix_cycle_days
),
engaging_deals as (
select sales_agent, datediff('day', engage_date, '2017-12-31') as deal_age
from sales_pipeline
where deal_stage in('Engaging')
),
classified as (
select sales_agent, deal_age, fix_cycle_days,
case when deal_age > fix_cycle_days then 'stalled'
else 'not_stalled' end as status
from engaging_deals
cross join threshold),

stalled_per_agent as (
select sales_agent, 
COUNT(*) FILTER (WHERE status = 'stalled') AS stalled_n,
COUNT(*) as open_deals
from classified
group by sales_agent)

select sta.sales_agent,
       st.regional_office,
       st.manager,
       sta.stalled_n,
       sta.open_deals,
       round(100.0 * sta.stalled_n / sta.open_deals, 1) as stalled_pct
from stalled_per_agent sta
join sales_teams st on sta.sales_agent = st.sales_agent
order by st.regional_office, st.manager, stalled_pct desc;
