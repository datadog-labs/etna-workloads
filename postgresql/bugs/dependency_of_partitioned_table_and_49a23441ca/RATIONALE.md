# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 49a23441ca7f314c25794a9a547011c0a858cfaa ("Fix dependency of partitioned table and table AM with CREATE TABLE .. USING"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/heap.c

Failing oracle cases:
- `src/test/regress||create_am`
