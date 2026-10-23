Business Questions



Data: CRM Sales Opportunities (Maven Analytics). Deals engaged Oct 2016 - Dec 2017;

closures Mar - Dec 2017. Quarterly analysis uses Q2-Q4 2017 only (Q1 contains

only March). Reference date for open deals: 2017-12-31.



Q1. Which agents under or over perform, and why?

\- Question: Which sales agents have a win rate and revenue below or above

&#x20; the company average?

\- Metric: Win rate = Won / (Won + Lost), on closed deals only. Revenue =

&#x20; SUM(close\_value) of Won deals. Both compared with the company average.

\- Decision:\*\* Who to talk to first about the problems they face, and which

&#x20; strong agents to pair with weaker ones (peer coaching).



Q2. How long does it take to close a won deal?

\- Question: How many days does a deal take from Engaging to Won, by agent

&#x20; and by product? Is the cycle longer for higher-priced products?

\- Metric: Cycle length = close\_date - engage\_date, on Won deals. Report

&#x20; mean and median.

\- Decision: If cycles differ by product, set realistic expectations per

&#x20; product. If they differ by agent on the same product, look at what slower

&#x20; agents do differently.



Q3. Are we growing, and where does growth come from?

\- Question: How does revenue change quarter over quarter (Q2 -> Q4 2017),

&#x20; and is the change driven by more deals won or by larger deals? Can I see it

&#x20; by account and by product?

\- Metric: Revenue = number of Won x average deal size. QoQ % change of

&#x20; revenue, of number of Won and of average deal size.

\- Decision: If growth comes from volume, invest in opportunity generation.

&#x20; If it comes from deal size, focus on the product mix.



Q4. Which open deals are stalled?

\- Question: How many deals sit in Engaging longer than normal, and who

&#x20; owns them?

\- Metric: Age = 2017-12-31 - engage\_date. A deal is "stalled" if its age

&#x20; exceeds the median cycle length of Won deals (from Q2). Report count and

&#x20; mean/median age by agent.

\- Decision: Which deals the sales manager should review first, and whether

&#x20; the problem is concentrated in specific agents or products.



limits

\- No loss reason, no probability, no costs, no sales targets in the data.

\- Prospecting deals have no dates, so only Engaging -> close can be measured.

\- close\_value varies about +/-30% around the suggested retail price.

\- Q4 may be affected by deals still open at the end of the dataset.

