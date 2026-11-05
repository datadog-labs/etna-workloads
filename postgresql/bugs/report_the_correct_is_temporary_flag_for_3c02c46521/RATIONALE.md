# Rationale
File: src/backend/commands/event_trigger.c, function EventTriggerSQLDropAddObject.
Traces to the fix.patch hunk adding the `object->classId == AttrDefaultRelationId` branch (column default is temp if its table is temp). I removed that branch, so column defaults fall to the generic handling (not in ObjectProperty), leaving istemp false, so pg_event_trigger_dropped_objects() reports is_temporary wrongly for defaults of temp tables.

Failing oracle case: src/test/regress||event_trigger
