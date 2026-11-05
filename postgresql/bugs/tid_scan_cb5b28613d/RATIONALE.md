# Rationale
Reverts use of the dedicated Tid-scan begin entry point (`table_beginscan_tid`), going back to a plain seqscan-flagged `table_beginscan`. The `SO_TYPE_TIDSCAN` enum value and `table_beginscan_tid` helper are left defined but unused, so the new-API hunks in tableam.h are not reverted (minimal change).

1. src/backend/executor/nodeTidscan.c, TidListEval: fix_impl hunk 1. `table_beginscan_tid(rel, snapshot)` -> `table_beginscan(rel, snapshot, 0, NULL)`. The scan is then flagged SO_TYPE_SEQSCAN with strategy/sync/pagemode, not as a Tid scan.
2. src/backend/utils/adt/tid.c, currtid_internal (formerly currtid_byreloid/byrelname): fix_impl hunks 2/3. Same replacement.

Failing oracle case: src/regress||tidscan
