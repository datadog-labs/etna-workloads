# fts5vocab "term < NULL" crash

Fix hunk reversed: `+ if( zCopy==0 ) zCopy = "";` in fts5VocabFilterMethod
(the assert_nc removal in fts5VocabNextMethod has no counterpart in 3.54.1; the assert is already gone).

In 3.54.1 the same defect is covered twice, in `ext/fts5/fts5_vocab.c`:
1. The `zCopy==0` fallback was deleted.
2. The `if( sqlite3_value_type(pLe)!=SQLITE_TEXT ) pLe = 0;` guard (a later
   addition that also covers the case) was deleted, so a NULL RHS reaches the copy.

With both gone, `fts5VocabValueText()` returns NULL for a non-text value and
`memcpy(pCsr->zLeTerm, NULL, 1)` runs, as before the fix.

Oracle: fts5vocab-10.6.1 (`term<NULL`) crashes testfixture; later cases don't run.
