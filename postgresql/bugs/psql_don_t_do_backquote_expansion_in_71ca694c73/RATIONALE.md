# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 71ca694c73cd1a808a393b2d5076e0518404468e ("psql: Don't do backquote expansion in \unrestrict."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/psql/command.c

Failing oracle cases:
- `src/bin/psql|t/001_basic.pl|\unrestrict does not do backquote expansion: exit code not 0`
- `src/bin/psql|t/001_basic.pl|\unrestrict does not do backquote expansion: matches`
