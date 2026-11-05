# Rationale

File: src/backend/commands/indexcmds.c, function ReindexIndex().

Traces to the fix.patch hunk in ReindexIndex(). That hunk replaced `indexRelation->relpersistence` with the index's actual persistence, which it read from the relcache. In current code the actual value comes from `get_rel_persistence(indOid)`. I changed that line back to `persistence = indexRelation->relpersistence;`.

The RangeVar's relpersistence is just the parser default (permanent), not the index's real persistence. So REINDEX INDEX on a temp or unlogged index passes the wrong persistence to reindex_index(). The persistence setting is lost. The check for whether to take the concurrent path is also made against the wrong value.

Failing oracle case: src/test/regress||create_table
