# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 040da42367a5de448ddecf6ee7c09f73580a6b28 ("Enable failure to rename a partitioned index"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/objectaddress.c

Failing oracle cases:
- `src/test/regress||alter_table`
