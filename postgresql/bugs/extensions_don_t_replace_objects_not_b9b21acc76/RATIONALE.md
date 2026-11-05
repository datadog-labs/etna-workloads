# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b9b21acc766db54d8c337d508d0fe2f5bf2daab0 ("In extensions, don't replace objects not belonging to the extension."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/catalog/pg_collation.c, src/backend/catalog/pg_depend.c, src/backend/catalog/pg_operator.c, src/backend/catalog/pg_type.c, src/backend/commands/createas.c, src/backend/commands/foreigncmds.c, src/backend/commands/schemacmds.c, src/backend/commands/sequence.c, src/backend/commands/statscmds.c, src/backend/commands/view.c, src/backend/parser/parse_utilcmd.c, src/include/catalog/dependency.h

Failing oracle cases:
- `src/test/modules/test_extensions||test_extensions`
