Reproducer: two small tables and a compound `SELECT ... UNION ALL SELECT ... ORDER BY x` (from insert3-1.4.1).
The injection sets `pRet->aSortFlags` to point into `aColl` in the compound-select ORDER BY KeyInfo, so the sort flags and collations are corrupted.
Clean shell prints the six sorted rows and exits 0. Buggy shell aborts on the assertion in sqlite3VdbeChangeEncoding (exit -6).
