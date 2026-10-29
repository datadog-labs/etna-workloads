repro.sql: creates table t1 in main, then a TEMP VIEW t1 selecting from t1 (itself), and queries temp.t1.
Clean: "view t1 is circularly defined" error (exit 1). Buggy: the circularity check is compiled out, so assert(pTable->nCol>=0) fails in viewGetColumnNames (abort).
