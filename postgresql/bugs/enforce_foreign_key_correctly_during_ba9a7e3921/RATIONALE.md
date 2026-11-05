# Rationale

## src/backend/commands/trigger.c, AfterTriggerSaveEvent(), `case RI_TRIGGER_PK`
Traces to the fix.patch hunk in AfterTriggerSaveEvent that makes the DELETE event
fired on the source leaf partition of a cross-partition update skip queuing
(`is_crosspart_update && TRIGGER_FIRED_BY_DELETE(event) && trigger->tgisclone` -> continue).
I removed that check. The leaf-partition DELETE now queues its own PK-side RI action
alongside the root table's update event. Cross-partition updates of a PK table are then
no longer enforced correctly: the foreign key action is taken twice, or the wrong one
(for example, ON DELETE actions run instead of ON UPDATE actions).

## Failing oracle cases
- src/test/regress||foreign_key
