# Rationale

Hunk: `src/backend/executor/nodeLockRows.c`, `ExecLockRows()`.
Traces to the fix.patch hunk in nodeLockRows.c that makes rels with already-visited
rowmarks return no tuple during the first EPQ test.

In today's code EPQ begins after the rowmark loop, and "no tuple for this rel" is
expressed by the `ExecClearTuple(markSlot)` at the top of each rowmark iteration
(the modern equivalent of the old `EvalPlanQualSetTuple(..., NULL)`). Removing it
leaves stale EPQ test tuples in the slots of inactive child rels (from a previous
row), so EPQ can re-return a row from an earlier, already-scanned child
table, which is the "row returned twice" bug.

Oracle case expected to fail: src/test/isolation||eval-plan-qual
