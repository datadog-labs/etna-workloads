Reproducer (repro.sql): a subquery uses count(t8.b), which aggregates against the outer query, alongside count(*) over t7.

- clean: "Parse error: misuse of aggregate: count()", exit 1.
- buggy: isSimpleCount() lacks the `pExpr->pAggInfo!=pAggInfo` check, so the count(*) optimization is misapplied. The shell aborts with the assertion `pAggInfo->aFunc[0].pFExpr==pExpr` (exit -6).
