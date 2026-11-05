# Rationale

Changed: src/backend/executor/nodeModifyTable.c, ExecInitModifyTable().
Traces to the fix.patch nodeModifyTable.c hunks: the "keep_rel" logic that keeps the first result relation when all are pruned, plus the `total_nrels` variable, `Assert(nrels > 0)`, and the asserts that were changed from `nrels` to `total_nrels`.
I reverted these: the loop again keeps only unpruned result rels, so when every result rel is pruned, no ResultRelInfo is initialized (nrels == 0). Later code that needs a first result relation (MERGE NOT MATCHED inserts, tuple routing) then has none, and `mtstate->resultRelInfo[0]` is used uninitialized.

Failing oracle case: src/test/regress||partition_prune
