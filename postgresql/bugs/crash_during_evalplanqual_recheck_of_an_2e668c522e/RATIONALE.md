# Rationale

File: src/backend/executor/nodeIndexscan.c, functions ExecIndexMarkPos and ExecIndexRestrPos.
Traces to the nodeIndexscan.c hunks of fix.patch. I removed the EvalPlanQual guard, which returns early when a test tuple exists for the relation. The current code expresses that guard through es_epq_active and relsubs_*, not es_epqTuple. Without it, a mark or restore inside an EPQ recheck calls index_markpos or index_restrpos on a NULL iss_ScanDesc, which crashes.

I did not touch the IndexOnlyScan hunks or the MergeJoin comment. The IndexScan change alone reproduces the failure.

Failing oracle case: src/test/isolation||eval-plan-qual
