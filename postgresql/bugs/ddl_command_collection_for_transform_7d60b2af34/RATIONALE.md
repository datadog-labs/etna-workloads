# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7d60b2af34842ae89b1abdd31fb5d303bd43c514 ("Fix DDL command collection for TRANSFORM"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/functioncmds.c, src/backend/tcop/utility.c, src/include/commands/defrem.h

Failing oracle cases:
- `src/test/modules/test_ddl_deparse||create_transform`
