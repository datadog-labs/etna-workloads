`repro.sql` runs a query whose window functions (`MIN(c0) OVER ()` and `CUME_DIST() OVER ()`) have incompatible frames and sit inside an EXISTS subquery used with BETWEEN (so the subquery is duplicated).
The injection removes the `sqlite3WindowLink` compatibility check in `gatherSelectWindowsCallback`.
Clean shell: prints `0`. Buggy shell: aborts with the assertion `pWin==pMWin || sqlite3WindowCompare(...)!=1` failing in `windowAggStep` (exit status -6).
