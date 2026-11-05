# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 5668a857de4f3f12066b2bbc626b77be4fc95ee5 ("Fix right-semi-joins in HashJoin rescans"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeHashjoin.c

Failing oracle cases:
- `src/test/regress||join`
