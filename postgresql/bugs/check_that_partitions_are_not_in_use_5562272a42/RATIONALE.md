# Rationale
Changed: src/backend/commands/tablecmds.c, ATPrepCmd, case AT_DropConstraint.
Traces to the fix.patch hunk that added `ATCheckPartitionsNotInUse(rel, lockmode);` there. I removed that call, so DROP CONSTRAINT on a partitioned table no longer locks the partitions or checks CheckTableNotInUse on them. Dropping a constraint can then run while a partition has active queries or pending trigger events. The helper function stays defined (it is now unused). The other hunks of the fix are cosmetic.

Failing oracle case: src/test/regress||foreign_key
