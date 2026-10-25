“Product ‘GTXPro’ in sales\_pipeline (1,480 rows) does not match ‘GTX Pro’ in products. Aligned to the master table, consistent with the naming of the other products. Raw CSV untouched; fix applied in 00\_load.sql.”

Only the closed opportunity have an account assigned.

Check: agents in sales\_teams with no deals in sales\_pipeline.

Found: 5 of 35 agents (2 West, 2 East, 1 Central; five different managers) have no deals. All agents in the pipeline exist in sales\_teams.

Treatment: no rows removed. Agent level analyses use the 30 active agents. Team averages are computed on active agents, and the choice is declared.

