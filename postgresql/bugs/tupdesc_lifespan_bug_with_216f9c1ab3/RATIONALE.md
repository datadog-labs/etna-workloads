# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 216f9c1ab3a4f333632ce576e1dc1e3643427eb8 ("Fix tupdesc lifespan bug with AfterTriggersTableData.storeslot."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c

Failing oracle cases:
- `src/test/regress||triggers`
