# Rationale

## src/t_zset.c, zuiNext(), intset branch of OBJ_SET
Fix hunk: `int64_t ell = val->ell;` -> `int64_t ell;` plus the added `val->ell = ell;` after `intsetGet`.
Reversed by removing `val->ell = ell;`, so the value read by `intsetGet` into the local is never stored in the iterator value.
The original bug likewise left `val->ell` unset. In 9.0.7 `val` is memset to 0 at the top of zuiNext, so every intset element is yielded as integer 0.
The local `ell` declaration is already uninitialised in 9.0.7, so only the store needed removing.

## Oracle failures
- `ZINTERSTORE #516 regression, mixed sets and ziplist zsets`: returns empty instead of `100`.
- `zunionInterDiffGenericCommand acts on SET and ZSET`: ZUNION of an intset and a zset gives `0 1 2 3 4 5` instead of `1 2 3 4 5`.
