# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2780538433fc3b40b4e1e7bc7cbd350e37b6d550 ("Check for USAGE privilege on types used by stored expressions."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/dependency.c, src/backend/catalog/heap.c, src/backend/catalog/index.c, src/backend/catalog/pg_attrdef.c, src/backend/catalog/pg_constraint.c, src/backend/catalog/pg_proc.c, src/backend/catalog/pg_publication.c, src/backend/catalog/pg_type.c, src/backend/commands/indexcmds.c, src/backend/commands/policy.c, src/backend/commands/statscmds.c, src/backend/commands/tablecmds.c, src/backend/commands/trigger.c, src/backend/commands/typecmds.c, src/backend/parser/parse_utilcmd.c, src/backend/rewrite/rewriteDefine.c, src/backend/tcop/utility.c, src/include/catalog/dependency.h, src/include/commands/typecmds.h

Failing oracle cases:
- `src/test/regress||privileges`
