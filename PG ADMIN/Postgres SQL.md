### &nbsp;			**Postgres SQL** 

&nbsp;					-------------------------------------------



**What work\_mem :**

----------------
	work\_mem is per-operation memory PostgreSQL uses for:
	sorting (ORDER BY),hash joins, hash aggregations, merge joins

👉 It is NOT global memory — it is allocated per query operation.

&nbsp;	>>For current query/session (local use):

&nbsp;		SET work\_mem = '32MB';

&nbsp;	>>Inside a PostgreSQL function:

&nbsp;		SET LOCAL work\_mem = '32MB';

👉`SET` applies to the session, `SET LOCAL` applies only within the function/transaction.



