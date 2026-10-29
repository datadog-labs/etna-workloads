Reproducer (repro.sql): a STRICT table with a STORED generated REAL column whose expression can yield TEXT, then an INSERT that triggers it.

Clean: "cannot store TEXT value in REAL column t.c", exit status 1.
Buggy: the OP_TypeCheck emitted before OP_MakeRecord keeps the MakeRecord's p3, so the shell hits the assertion `pOp->p3>=0 && pOp->p3<pTab->nCol+2` in sqlite3VdbeExec and aborts (exit -6).
