Product ‘GTXPro’ in sales\_pipeline (1,480 rows) does not match ‘GTX Pro’ in products. Aligned to the master table, consistent with the naming of the other products. Raw CSV untouched; fix applied in 00\_load.sql.

Only the closed opportunity have an account assigned.

Check: agents in sales\_teams with no deals in sales\_pipeline.

Found: 5 of 35 agents (2 West, 2 East, 1 Central; five different managers) have no deals. All agents in the pipeline exist in sales\_teams.

Treatment: no rows removed. Agent level analyses use the 30 active agents. Team averages are computed on active agents, and the choice is declared.

Uniqueness check on the key of each table (opportunity\_id, account, product, sales\_agent): no duplicates found. Not checked: the same deal repeated under different IDs

Impossible dates: close\_date earlier than or equal to engage\_date on closed deals (Won, Lost). Found: 0 rows. Cycle length ranges 1-138 days. No action needed.

