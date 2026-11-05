# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9d1a5354f58cf61d9be6733d5ad0b36936af5af3 ("Fix costing bug in MergeAppend"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/optimizer/util/pathnode.c

Failing oracle cases:
- `src/test/regress||inherit`
