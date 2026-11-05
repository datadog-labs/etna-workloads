# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9f7c803c91584fb6e4b45dc87de44bac370477a9 ("Remove faulty Assert in partitioned INSERT...ON CONFLICT DO UPDATE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c

Failing oracle cases:
- `src/test/isolation||insert-conflict-do-update-4`
