# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c70b6db34ffeab48beef1fb4ce61bcad3772b8dd ("Fix concurrent update issue with MERGE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c, src/include/access/tableam.h

Failing oracle cases:
- `src/test/isolation||merge-match-recheck`
