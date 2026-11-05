# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9f4f0a0dad4c7422a97d94e4051c08ec6d181dd6 ("Fix incorrect logic in HaveRegisteredOrActiveSnapshot()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/time/snapmgr.c

Failing oracle cases:
- `src/test/regress||portals`
