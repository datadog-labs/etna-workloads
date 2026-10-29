# Rationale

The fix's `src/alter.c` hunk still applied in spirit to 3.54.1 (same code in `sqlite3AlterFinishAddColumn`), so all three parts were reverted in `tree/src/alter.c`:

1. Removed `|| (pTab->tabFlags & TF_Strict)!=0` from the "verify constraints" condition. A STRICT table no longer triggers the quick_check pass after ADD COLUMN.
2. Removed the `WHEN quick_check GLOB 'non-* value in*' THEN raise(ABORT,'type mismatch on DEFAULT')` arm of the CASE.
3. Restored the WHERE clause to `quick_check GLOB 'CHECK*' OR quick_check GLOB 'NULL*'`, dropping the `non-* value in*` alternative.

Result: `ALTER TABLE t1 ADD COLUMN b TEXT DEFAULT x'313233'` on a non-empty STRICT table succeeds even though the default violates the column type.

Oracle failure: `alter-20.2` fails. It expects `1 {type mismatch on DEFAULT}` and gets `0 {}`. The second `alter-20.2` fails too, with "duplicate column name: b", because the column was wrongly added by the first.
