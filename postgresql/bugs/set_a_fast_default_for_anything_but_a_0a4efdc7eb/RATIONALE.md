# Rationale

Fix: "Don't set a fast default for anything but a plain table". Current code has changed, so the bug is re-expressed in three places.

1. `src/backend/commands/tablecmds.c`, `ATExecAddColumn`, relkind check on the missing-value path.
   Traces to the fix.patch heap.c `StoreAttrDefault` hunk (`relkind == RELKIND_RELATION && add_column_mode && !attgenerated`).
   That logic now lives in `ATExecAddColumn`, so I removed `rel->rd_rel->relkind == RELKIND_RELATION &&` there.
   Any relation reaching this block can now get a stored missing value.
2. Same function, outer guard `if (RELKIND_HAS_STORAGE(relkind))`, widened to `|| relkind == RELKIND_FOREIGN_TABLE`.
   Same fix hunk as above. Today this guard also keeps storage-less relations out, which masks hunk 1 on its own.
   Foreign tables are the case the test covers, so without this change hunk 1 has no effect on them.
   This guard was not in the original fix, so it is an adaptation to current code.
3. `src/backend/catalog/heap.c`, `SetAttrMissing`.
   Traces to the fix.patch heap.c `SetAttrMissing` hunk. I removed the "Don't do anything unless it's a plain table" early return.
   The pg_upgrade support function can then set missing values on non-plain relations.

Together, `ALTER FOREIGN TABLE ft1 ADD COLUMN c8 integer DEFAULT 0` sets `attmissingval` and `atthasmissing` on a foreign table.
The final `pg_attribute` count in the regression test is then non-zero.

Failing oracle case: `src/test/regress||fast_default`
