# Rationale

Changed: src/backend/executor/nodeAgg.c, ExecReScanAgg(). This traces to the nodeAgg.c hunk of fix_impl.patch.
The fix added `!bms_overlap(node->ss.ps.chgParam, aggnode->aggParams)` to the condition for reusing an existing hash table on rescan.
I removed that check. A hashed Agg with a changed Param used in aggregate inputs now reuses its stale hash table and repeats the previous results.
The planner-side aggParams plumbing is left in place and is simply unused.

Failing oracle case: src/test/regress||aggregates
