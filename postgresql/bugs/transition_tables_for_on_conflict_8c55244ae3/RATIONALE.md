# Rationale

Changed: `src/src/backend/commands/trigger.c`, `MakeTransitionCaptureState()`.

Traces to the fix.patch hunks in `MakeTransitionCaptureState` and `AfterTriggerSaveEvent`. Those hunks split the single new-tuple tuplestore into separate INSERT and UPDATE tuplestores. Today's code keeps one `AfterTriggersTableData` per (relation, command) instead of `tcs_insert_tuplestore` and `tcs_update_tuplestore`.

The change: when the relation has an INSERT trigger with a NEW TABLE, the UPDATE capture state uses the INSERT table data (`CMD_INSERT`) instead of the UPDATE one. In `INSERT ... ON CONFLICT DO UPDATE`, the inserted rows and the updated rows then go into one shared new-tuple tuplestore. This is the pre-fix behavior: INSERT and UPDATE triggers each see both sets of new rows.

I did not re-add the multi-event restriction check in `CreateTrigger`. The current code still has that check, and the original fix added it, so removing it would not be part of re-expressing the bug.

Failing oracle case: `src/test/regress||triggers`. `plpgsql` still passes.
