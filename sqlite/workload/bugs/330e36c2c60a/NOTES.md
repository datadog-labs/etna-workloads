repro.sql replays fts5contentless3 test 3.0-3.5: a contentless_delete FTS5 table with pgsz=64,
optimized, some rows deleted, then an incremental `merge` with a negative argument (optimize-style).
Clean: ft_data row counts are 197 then 200. Buggy: 203 then 203, because the incremental
optimization does not merge/rewrite the single segment that has tombstone pages.
(fts5_structure() isn't available in the shell, so the structure checks 3.6/3.7 were dropped.)
