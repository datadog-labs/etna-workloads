# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 50b797dc99ec3bf97ea5d0955a3b42d356c1522d ("Fix DROP ROLE when specifying duplicated roles"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/user.c

Failing oracle cases:
- `src/test/regress||create_role`
