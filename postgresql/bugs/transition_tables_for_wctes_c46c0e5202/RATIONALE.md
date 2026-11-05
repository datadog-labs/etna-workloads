# Rationale

File: src/backend/commands/trigger.c, function GetAfterTriggersTableData().

Traces to the fix.patch trigger.c hunks that moved the transition tuplestores out of the
per-query-depth arrays (afterTriggers.old_tuplestores/new_tuplestores[query_depth]) and into
a per-ModifyTable TransitionCaptureState. Before the fix, every DML statement at the same
query level (e.g. wCTEs) shared one tuplestore.

Current code has since evolved into per-query-level AfterTriggersTableData structs keyed by
(relid, cmdType). I re-expressed the bug by dropping the `relid` comparison from the lookup,
so all DML of the same command type at one query level shares one transition tuplestore
regardless of target table. With
`with wcte as (insert into table1 ...) insert into table2 ...` both statements' statement
triggers see the same mixed tuplestore, so the transition tables are wrong, which is the wCTE failure.

Failing oracle case: src/test/regress||triggers
