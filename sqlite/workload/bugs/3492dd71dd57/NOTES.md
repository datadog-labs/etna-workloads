Inserts into a view with an INSTEAD OF trigger whose body inserts into an AUTOINCREMENT table (ticket a696379c1f088).
No cursor is opened, so nTab is 0 while autoincrement is used.
Clean shell prints `1|10123`. Buggy shell aborts on assertion `pParse->usesAinc==0 || pParse->nTab>0` in sqlite3FinishCoding (exit -6).
