# Rationale

In this tree the EXEC_CHECK_QUERY_ID macro and the old assertions no longer exist. The executor entry points had no query-ID assertion at all. I restored the pre-fix, weaker assertion.

Changed file: src/backend/executor/execMain.c, in ExecutorRun, ExecutorFinish and ExecutorEnd.
Each one gets `Assert(!IsQueryIdEnabled() || pgstat_get_my_query_id() != 0);`.

These trace to the three fix.patch hunks that replaced that same assertion with EXEC_CHECK_QUERY_ID. The fix added exceptions for `!pgstat_track_activities` and `!debug_query_string`, and I left those out.

The bug returns because the assertion demands a nonzero query ID even when track_activities is off or no client query string exists. Query ID reporting is skipped in those cases, so the assertion fires wrongly.

Oracle cases that fail (confirmed by agent_oracle.py): src/test/regress||guc (1/1 failing). I did not inspect the failure diff.
