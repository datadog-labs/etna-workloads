# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit ccacaf4fae242cf71ed5d4f7c39ca0645ca4ca9c ("Fix inconsistent quoting of role names in ACLs."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/utils/adt/acl.c

Failing oracle cases:
- `src/test/regress||privileges`
