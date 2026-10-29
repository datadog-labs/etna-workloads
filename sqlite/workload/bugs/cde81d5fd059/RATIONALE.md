# Rationale

Hunk reversed: `ext/fts3/fts3.c`, `fts3InitVtab()`, "Fill in the abNotindexed array".
The fix added a length-equality check (`strlen(zNot)==n`) before `sqlite3_strnicmp(..., n)`.
In 3.54.1 it is written `n==(int)strlen(zNot)`; I removed it, restoring the pre-fix
condition `zNot && 0==sqlite3_strnicmp(p->azColumn[iCol], zNot, n)`. A column whose name
is a prefix of a notindexed column name is again marked notindexed (and consumes that entry).

Oracle failures (test/fts4noti.test): fts4noti-6.1.2, 6.1.3, 6.1.4, 6.1.5, 6.3.1.
With `fts4(poiCategory, poiCategoryId, notindexed=poiCategoryId)`, `poiCategory` is
wrongly not indexed, so MATCH 'restaurant' returns nothing, while `poiCategoryId` is indexed, so MATCH '6021' matches.
