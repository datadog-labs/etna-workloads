repro.sql: a query combining a window function (`count(*) OVER ()`) with a correlated scalar subquery whose JOIN has an ON clause referencing the outer table (`t3.c`, NULL).

The window rewrite (selectWindowRewriteExprCb) drops the EP_OuterON/EP_InnerON flags and iJoin on the rewritten expression. With the bug, the ON-clause term is handled as a plain WHERE term, so the join rows are lost.

Clean output: `1|1`, `1|1`, `1|2`. Buggy output: `1|0`, `1|0`, `1|0` (the LEFT, RIGHT and FULL JOIN variants). These correspond to windowD-3.2, 3.6 and 3.7.
