# SORT key extraction (sortGetKeys, src/db.c)

Fix hunks reversed (both in `sortGetKeys`):
1. Removed the `found_store` variable and its `found_store = 1;` assignment in the STORE branch.
2. `result->numkeys = num + found_store;` -> `result->numkeys = num;` (the pre-fix `*numkeys = num`).

The 9.0.7 function is the same algorithm with keyReference/getKeysResult instead of int arrays, so the reversal is direct. The STORE key is written to `keys[num]` but never counted, so `COMMAND GETKEYS sort abc store def` returns only `abc`.

Failing oracle cases (unit/sort):
- "SORT extracts STORE correctly": expected `abc def`, got `abc`.
- "SORT extracts multiple STORE correctly": expected `abc def`, got `abc`.
