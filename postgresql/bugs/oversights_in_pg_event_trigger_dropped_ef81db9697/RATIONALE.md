# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ef81db9697a082300b452c8dd6824d2d07f5f557 ("Fix oversights in pg_event_trigger_dropped_objects() fixes."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/event_trigger.c

Failing oracle cases:
- `src/test/regress||event_trigger`
