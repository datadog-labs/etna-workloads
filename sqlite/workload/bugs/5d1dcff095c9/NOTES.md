Reproducer: repro.sql opens two connections (via `.connection`) to a shared-cache in-memory DB.
Connection 0 does BEGIN; DELETE FROM t2 (OP_Clear optimization); connection 1 then SELECTs from t2.
Clean: "database table is locked: t2" (exit 1). Buggy: the write-lock is not taken, so the SELECT silently succeeds (exit 0, no error).
