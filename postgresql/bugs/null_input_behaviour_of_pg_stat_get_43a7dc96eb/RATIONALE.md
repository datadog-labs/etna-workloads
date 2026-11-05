# Rationale

Changed hunk: `src/include/catalog/pg_proc.dat`, entry for `pg_stat_get_replication_slot` (oid 6169).
Traces to the `pg_proc.dat` hunk of fix.patch, which removed `proisstrict => 'f'`. I added it back, so the function is non-strict again and NULL input is no longer handled by the executor (it returns NULL).
The C function calls `PG_GETARG_TEXT_P(0)` without a null check, so a NULL argument is dereferenced as if it were a valid value. This is the bug the fix removed.

The catversion.h hunk was not reproduced because it is not part of the bug's behaviour.

Failing oracle case: `src/test/regress||stats`
