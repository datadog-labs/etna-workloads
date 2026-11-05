# Re-introducing "pg_dump emits PARTITION OF instead of ATTACH PARTITION"

Changes (all trace to fix_impl.patch, which reverses the original change; here we re-apply the old behavior):

- src/bin/pg_dump/pg_dump.c `shouldPrintColumn`: partitions no longer always print all columns (hunks 1/2).
- `dumpTableSchema`: emit ` PARTITION OF parent` after CREATE TABLE (non-binary-upgrade), with the bound fetched via a query because the current code no longer stores partbound in TableInfo (hunk 3); skip columns fully defined by the parent, skip types for partitions, no empty `()` for partitions, append partition bound (hunks 4-7).
- src/bin/pg_dump/common.c `flagInhTables`: TableAttachInfo (the current-code form of the removed ATTACH PARTITION block, last hunk) is created only in binary-upgrade mode.

Effect: ordinary dumps use CREATE TABLE ... PARTITION OF again, losing column layout/tablespace fidelity, so the pg_dump TAP expectations (partition creation / ATTACH output) fail.

Failing oracle cases: 10072 of 13808, all in src/bin/pg_dump t/002_pg_dump.pl (e.g. "Partition measurement_y2006m2 creation" and many dependent per-run cases).
