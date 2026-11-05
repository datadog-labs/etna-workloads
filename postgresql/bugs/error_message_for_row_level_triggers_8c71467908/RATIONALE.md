# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 8c7146790811ac4eee23fab2226db14b636e1ac5 ("Correct error message for row-level triggers with transition tables on partitioned tables."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/trigger.c

Failing oracle cases:
- `src/test/regress||triggers`
