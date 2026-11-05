# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 39e3bcae44868734504c3decbb6708c36a5a84b2 ("Fix an ALTER GROUP ... DROP USER error message."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/user.c

Failing oracle cases:
- `src/test/regress||privileges`
