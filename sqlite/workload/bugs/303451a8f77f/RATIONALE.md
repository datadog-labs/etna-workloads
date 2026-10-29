# Rationale

Fix hunk (src/window.c, sqlite3WindowDup): the buggy code duplicated
`pNew->pStart` / `pNew->pEnd` (freshly zeroed, so always NULL) instead of
`p->pStart` / `p->pEnd`. The fix changed them to `p->`. In 3.54.1 the code
had the fixed form; I reverted both lines in `sqlite3WindowDup` (src/window.c ~2408-2409)
to the `pNew->` form. Window frame offset expressions are lost on any duplicated window,
so frames like `ROWS BETWEEN N PRECEDING AND M FOLLOWING` misbehave when the statement
has multiple windows and Window objects get duplicated.

Oracle: test/window4.test, 40 of 224 cases fail (window4-4.5.34.x through 4.5.56.x).
