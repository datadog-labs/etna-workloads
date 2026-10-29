Reproducer (repro.sql): builds the fts5securefault-6 table (pgsz=64, 3 identical rows), enables
secure-delete, then drops the `t1_config` shadow table (defensive off) so the lazy
"version" REPLACE inside fts5FlushSecureDelete() fails without needing an OOM. The UPDATE then
flushes with p->rc set.
Clean: "Error: database disk image is malformed", exit 1.
Buggy: assertion `p->rc==SQLITE_OK` fails in fts5WriteAppendTerm (missing rc check), abort (exit -6).
