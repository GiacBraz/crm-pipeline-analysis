--win rate opportunities calculation (opp_won/opp_won+opp_lost)

select 
	count(opportunity_id) filter (where deal_stage='Won') as opp_vinte, 
	count(opportunity_id) filter (where deal_stage='Lost') as opp_perse, 
	opp_vinte+opp_perse as vinte_e_perse,
	round(opp_vinte/vinte_e_perse, 3) as win_rate 
from sales_pipeline
where close_date >= '2017-04-01'
group by quarter(close_date) 
order by quarter(close_date) ASC;