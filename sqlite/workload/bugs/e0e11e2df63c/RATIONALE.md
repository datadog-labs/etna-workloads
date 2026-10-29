# Rationale

Fix removed leftover SQLite-2 change-counting from `sqlite3_exec()` (src/legacy.c).
In 3.54.1 that code was already gone, so I re-added it in `src/legacy.c`:

- Re-added local `nChange` (fix hunk 1, `-int nChange = 0;`).
- Re-added `db->nChange += nChange;` before running each statement (fix hunk 2).
- Re-added, after finalize, `if( db->nVdbeActive==0 ) nChange = db->nChange;` (fix hunk 3). `db->pVdbe==0` in 2007 means "no active statements"; the modern equivalent is `db->nVdbeActive==0`.

Effect: in `update ...; select 1;` the update's count is added again when the next
statement starts, and the SELECT doesn't reset it, so `changes()` is doubled.

Oracle failure: `laststmtchanges-1.2.1` (expects 5, gets doubled count). The other cases still pass.
