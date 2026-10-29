The upstream test needs simulated OOM; the shell can't inject one, but `PRAGMA hard_heap_limit=86750`
makes a malloc fail during preparation of the windowfault-10 query (window frame ORDER BY containing
a sub-select that itself uses a window function).
Clean: `Parse error ... out of memory (7)`, exit 1. Buggy: assertion failure
`gatherSelectWindowsCallback: Assertion 'pWin' failed` (abort, exit 134) after the OOM in sqlite3SelectDup.
The limit value is tuned to this build; deterministic for it.
