# Rationale

File: src/backend/replication/logical/worker.c

1. `create_edata_for_relation()`: removed `AfterTriggerBeginQuery()`. Traces to the fix.patch hunk adding "Prepare to catch AFTER triggers" in `create_estate_for_relation`.
2. `finish_edata()`: removed `AfterTriggerEndQuery(estate)`. Traces to the fix.patch hunks adding "Handle queued AFTER triggers" in the insert/update/delete handlers. Today these three are consolidated in `finish_edata`.

Without these calls the apply worker never sets up or fires the AFTER trigger queue. AFTER triggers, including FK constraint triggers, are not executed on the subscriber.

Failing oracle cases (all 6 in 003_constraints.pl):
- check FK ignored on subscriber
- check column trigger applied even on update for other column
- check replica insert trigger applied on subscriber
- check replica update column trigger applied on subscriber
- check replicated tab_fk inserts on subscriber
- check replicated tab_fk_ref inserts on subscriber

All 6 show as 'missing' rather than a diff. The test script probably aborts early, so the failures may not all be separate symptoms.
