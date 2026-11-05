# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 05c0258966b502fae1bd63dcbe74d52f5c6f6948 ("Fix bug #16784 in Disk-based Hash Aggregation."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/executor/nodeAgg.c

Failing oracle cases:
- `src/test/regress||groupingsets`
