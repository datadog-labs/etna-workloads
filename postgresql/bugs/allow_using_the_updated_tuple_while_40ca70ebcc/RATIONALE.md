# Rationale

Hunk: src/backend/executor/nodeModifyTable.c, ExecDelete() (TM_Updated / table_tuple_lock TM_Ok case).
Traces to the fix_impl.patch hunk in ExecDelete that, after EvalPlanQual() returns a tuple, passes it back via
epqslot and returns NULL when the caller asked for it (`if (epqslot) {*epqslot = my_epqslot; return NULL;} else goto ldelete;`).
In current code that is `if (epqreturnslot) {...return NULL;} else goto ldelete;`. I removed the branch so it always does `goto ldelete`.
Effect: when a cross-partition UPDATE's DELETE half finds a concurrently updated row, it re-deletes the new row version
instead of handing the updated tuple back to ExecCrossPartitionUpdate for re-evaluation of the UPDATE, so the updated tuple is not used (the original bug).

Failing oracle case: src/test/isolation||partition-key-update-4
