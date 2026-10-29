# Rationale

Fix (2021-11-16): the OOM in `ALTER TABLE ADD COLUMN ... CHECK` went unreported
because `sqlite3RunParser()` kept the outer parse context in a `Parse.pParentParse`
field. `sqlite3NestedParse()` re-enters `sqlite3RunParser()` on the *same* Parse
object, so the nested call overwrote and then zeroed the field, and the outer
call then restored `db->pParse` to NULL. Later OOMs in the outer parse were not
recorded against any Parse. The fix made the context a local variable.

Hunks reversed (all three fix hunks):
- `src/sqliteInt.h`: re-add `Parse *pParentParse` (in the zero-initialised header
  part of Parse, not the tail saved/restored by sqlite3NestedParse).
- `src/tokenize.c` (declaration + start): `pParentParse = db->pParse` becomes
  `pParse->pParentParse = db->pParse`; the local declaration is removed.
- `src/tokenize.c` (end): `db->pParse = pParse->pParentParse; pParse->pParentParse = 0;`.

Current code differs from 2021 in that `sqlite3ParseObjectInit`/`sqlite3Prepare`
already set `db->pParse` (via `pOuterParse`) before RunParser, so the stored
"parent" is the Parse itself. Nested RunParser on the same Parse then zeroes the
field and the outer RunParser sets `db->pParse = NULL`.

Result: this trips `assert(db->pParse==pParse)` in `sqlite3ParseObjectReset`
(debug build); alterfault-1.0 crashes, so all 4462 oracle cases fail. In a
non-assert build, db->pParse is NULL and OOMs are not recorded in the Parse,
i.e. go unreported. The breakage is broader than the original (any
NestedParse), since the surrounding code changed.
