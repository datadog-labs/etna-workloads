Reproducer (repro.sql): an fts5 detail=none table with rows 'in if' and 'if', queried with the prefix 'i*'.
The prefix query merges the rowid lists for 'if' and 'in' in fts5MergeRowidLists().
The injected bug advances p2 before comparing it with p1, so duplicate rowids are handled wrongly.
Clean shell: prints rows 1 and 2, exit 0.
Buggy shell: assertion failure `iOut==0 || iRowid1>iOut` in fts5MergeRowidLists, abort (exit -6).
