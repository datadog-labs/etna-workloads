# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0101f770a05b07dd7a8e05b6f8f95d4e22f4e846 ("Fix a bug in roles_is_member_of."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/utils/adt/acl.c

Failing oracle cases:
- `src/test/regress||privileges`
