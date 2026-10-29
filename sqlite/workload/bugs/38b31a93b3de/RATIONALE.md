# Rationale

## Changed: src/vdbeapi.c, sqlite3_preupdate_old()
Reverses the `src/vdbeapi.c` hunk of the fix. In version-3.54.1 the branch
`iStore>=p->pUnpacked->nField` (column added by ALTER TABLE ADD COLUMN after
the record was written) looked up the column's default expression via
`sqlite3ValueFromExpr()` and cached it in `p->apDflt`. It is replaced by the
pre-fix code, which returns `columnNullValue()` for every such column.
The `apDflt` field (vdbeInt.h hunk) and its cleanup in sqlite3VdbePreUpdateHook()
(vdbeaux.c hunk) are left in place; with the lookup removed `apDflt` is always
NULL, so the cleanup is a no-op. The session hunk only handles an error return
that can no longer occur, so it was not reverted.

## Oracle failures
- hook-13.2: DELETE old.* shows `{} {} {}` instead of `1234 abcdef {}`.
- hook-13.3: UPDATE old.* shows NULLs instead of the defaults.
- hook-7.5.2.1 and hook-7.5.2.2 fail the same way (old.* default values
  of an ALTER TABLE-added column come back NULL).
