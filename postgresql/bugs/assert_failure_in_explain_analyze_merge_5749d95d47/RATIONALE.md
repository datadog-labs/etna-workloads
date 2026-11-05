# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5749d95d47941d1240e68ad0f4e0eba0e569aeb8 ("Fix Assert failure in EXPLAIN ANALYZE MERGE with a concurrent update."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c

Failing oracle cases:
- `src/test/isolation||merge-update`
