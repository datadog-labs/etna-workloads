# Rationale

9.0.7 still contained the fix's checks verbatim (only the `->ptr` vs `objectGetVal()` accessor differs), so the fix is reversed by deleting them.

- `src/cluster_migrateslots.c`, `clusterRDBLoadSlotImport()`: removed the `sdslen(job_name->ptr) != CLUSTER_NAMELEN` check. This reverses the first fix hunk. A short `job_name` from the RDB reaches `createSlotImportJob()`, which `memcpy`s `CLUSTER_NAMELEN` bytes (heap over-read).
- `src/valkey-check-rdb.c`, `RDB_OPCODE_SLOT_IMPORT` branch: removed the same length check. This reverses the second fix hunk. `valkey-check-rdb` then reports "RDB looks OK" for a short name.

## Failing oracle cases (`./check.sh`)
- `Server rejects RDB slot-import job_name shorter than CLUSTER_NAMELEN`: the server loads the crafted RDB, creates an import job named "A" and reports "Ready to accept connections" instead of failing closed.
- `valkey-check-rdb rejects short slot-import job_name`: no "RDB ERROR DETECTED" or "Invalid slot import job name length" is produced.
