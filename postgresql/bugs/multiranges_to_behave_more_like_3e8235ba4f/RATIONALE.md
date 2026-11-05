# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3e8235ba4f9cc3375b061fb5d3f3575434539b5f ("Fix multiranges to behave more like dependent types."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/catalog/aclchk.c, src/backend/catalog/pg_type.c, src/backend/commands/typecmds.c, src/bin/pg_dump/pg_dump.c

Failing oracle cases:
- `src/test/regress||dependency`
- `src/test/regress||multirangetypes`
