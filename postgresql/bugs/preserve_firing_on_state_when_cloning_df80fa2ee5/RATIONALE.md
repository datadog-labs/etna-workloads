# Rationale
Reverts the fix by making triggers always created with tgenabled = 'O' instead of the supplied firing-on state.

- src/backend/commands/tablecmds.c, CloneRowTriggersToPartition: fix.patch hunk replacing CreateTrigger with CreateTriggerFiringOn(..., trigForm->tgenabled). Now passes TRIGGER_FIRES_ON_ORIGIN, so cloned triggers lose the parent's enabled/disabled/always/replica state.
- src/backend/commands/trigger.c, CreateTriggerFiringOn: hunk storing trigger_fires_when in tgenabled; now hardcoded to TRIGGER_FIRES_ON_ORIGIN.
- trigger.c, recursive partition creation call in CreateTriggerFiringOn: hunk passing trigger_fires_when to children; now passes ORIGIN.

Failing oracle case: src/test/regress||triggers
