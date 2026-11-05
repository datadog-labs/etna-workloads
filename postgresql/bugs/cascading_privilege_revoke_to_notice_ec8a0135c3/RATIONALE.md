# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ec8a0135c3228087761ad3cdba18aebb01c7e17a ("Fix cascading privilege revoke to notice when privileges are still held."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/acl.c

Failing oracle cases:
- `src/test/regress||privileges`
