`repro.sql` builds an fts5 table and calls `highlight(ft, 0, NULL, NULL)` with NULL open and close markers.

- clean: returns `a b c x c d e`.
- buggy: segfaults (exit -11). `fts5HighlightAppend` lost its `&& z` check, so it calls `strlen(NULL)`.
