# Rationale

Reverts the fix "Fix resolution of unqualified rowid identifiers in queries with nested joins" (src/resolve.c, src/sqliteInt.h).

- `sqlite3MatchEName()` (resolve.c, sqliteInt.h): restored the old `int bRowidOk` parameter in place of `int *pbRowid`. ENAME_ROWID entries match only if `bRowidOk` is true and `zTab!=0`. This reverses hunks 1-3 of resolve.c and the sqliteInt.h prototype hunk. The `pbRowid` out-flag is gone.
- `lookupName()` nested-FROM loop: restored `sqlite3MatchEName(..., cnt==0)`. A rowid match is no longer distinguished from a real column match. It goes through the ambiguity and USING logic, then does `cnt++`, `cntTab = 2`, `hit = 1`. This reverses the `bRowid` branches. The newer `pMatch==pItem` USING check is kept.
- Tail of `lookupName()`: restored `ALWAYS(VisibleRowid(pMatch->pSTab))` and unconditional `pExpr->iColumn = -1`, removing the `isNestedFrom` exceptions.

## Oracle failures
test/joinH.test: joinH-9.2, 9.3, 9.9, 9.10 and 9.11 fail. These are the unqualified `rowid` / `_rowid_` cases over nested joins with WITHOUT ROWID tables, which the fix's new tests 9.x cover.
