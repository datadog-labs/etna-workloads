Reproducer: repro.sql (rowvalue-23.100). Table with a NOCASE column `aa` and `bb`,
row ('a','A'). `WHERE (+bb,1) >= (aa,1)` is commuted by exprCommute(); with the bug,
vector comparisons don't get EP_Commuted set, so the collation is picked wrongly.
Clean shell prints `0|1` then `3`; buggy shell prints `0|1`, `2`, `3` (extra row from the
second SELECT).
