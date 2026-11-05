# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 7650eabb662f2f3708042c0b713c46aa042db94f ("Fix unsafe pushdown of quals referencing grouping Vars"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/optimizer/path/allpaths.c, src/backend/optimizer/util/var.c

Failing oracle cases:
- `src/test/regress||subselect`
