# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit cb9db2ab0674381b92559e011738f19e2bd0f6f2 ("Fix ALTER TABLE...SET STATS error message for included columns"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||index_including`
