# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 29ef1dd19b4f3eb54569b2eece4a8a65034a2216 ("Fix handling of self-modified tuples in MERGE."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/executor/nodeModifyTable.c

Failing oracle cases:
- `src/test/isolation||merge-update`
- `src/test/regress||triggers`
