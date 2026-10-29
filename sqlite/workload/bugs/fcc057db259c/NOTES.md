`repro.sql` runs a compound SELECT (`VALUES(1) INTERSECT SELECT * WINDOW f AS () ORDER BY x COLLATE nocase`) whose ORDER BY forces conversion of the compound to a subquery. Without the fix, the converted Select keeps `pWinDefn`, so the window definition is freed twice.
Clean shell: "Parse error near line 1: no tables specified", exit 1. Buggy shell: segfault (exit 139).
