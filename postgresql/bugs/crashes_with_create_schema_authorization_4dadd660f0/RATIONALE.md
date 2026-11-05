# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 4dadd660f0719206ce3914d4ad9b6aad69d6db6e ("Fix crashes with CREATE SCHEMA AUTHORIZATION and schema elements"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/schemacmds.c, src/backend/parser/parse_utilcmd.c, src/include/parser/parse_utilcmd.h

Failing oracle cases:
- `src/test/regress||create_schema`
