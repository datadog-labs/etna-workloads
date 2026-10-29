# Rationale

Fix: optimizing an fts5 table too often made it unreadable, because the
optimized structure grew an extra level on every optimize without bound
(past FTS5_MAX_LEVEL=64, which the reader rejects as a corrupt structure).

## Change (ext/fts5/fts5_index.c, fts5IndexOptimizeStruct)

In 3.54.1 the fix is present in a rewritten form: `pNew->nLevel` is
`MIN(pStruct->nLevel+1, FTS5_MAX_LEVEL)` and the new level is
`aLevel[pNew->nLevel-1]`. I restored the pre-fix code:

- `pNew->nLevel = pStruct->nLevel+1;` (no cap)
- `pLvl = &pNew->aLevel[pStruct->nLevel];` (reverses the fix's
  `MIN(pStruct->nLevel, FTS5_MAX_LEVEL-1)` clamp)

`FTS5_MAX_LEVEL` is still defined and enforced by the structure reader, so
the unbounded level count is detected as corruption.

## Oracle failures

fts5optimize2.test: 1.1 and 1.2 fail with
`fts5: corrupt structure record for table "t1"`, after repeated
optimize calls push the level count beyond 64. (1.0 is just the CREATE.)
