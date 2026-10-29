# Rationale

Hunk reversed: `src/select.c`, `convertCompoundSelectToSubquery()`: removed `p->pWith = 0;`
(the fix's single implementation line). The WITH clause was copied to `pNew` by `*pNew = *p`,
and without clearing it the outer wrapper `p` keeps a stale, shared `pWith` pointer.

Oracle failure: `with1-14.1` (`WITH x AS (...) SELECT 0 EXCEPT SELECT 0 ORDER BY 1 COLLATE binary`)
aborts with assertion `pParse->pWith!=pWith` in `sqlite3WithPush`.
