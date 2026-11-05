# Rationale

## Changed hunk
- File: src/bin/psql/startup.c, function main(), single-transaction finish block.
- Traces to the fix.patch hunk in startup.c that replaced the unconditional `PSQLexec("COMMIT")` with `COMMIT`/`ROLLBACK` chosen from `successResult`.
- The current code also requires `pset.on_error_stop` for ROLLBACK. I reverted it to the pre-fix form, an unconditional `COMMIT`. After a client-side error in a -c/-f step under --single-transaction, psql now commits the partial work instead of rolling back.

## Failing oracle cases (6/131 fail)
Tests in src/bin/psql/t/001_basic.pl:
- client-side error rolls back transaction, ON_ERROR_STOP and multiple -c switches
- --single-transaction commits transaction, ON_ERROR_STOP and multiple -f switches
- client-side error rolls back transaction, ON_ERROR_STOP and multiple -f switches
- client-side error commits transaction, no ON_ERROR_STOP and multiple -f/-c switches
- client-side error commits transaction, no ON_ERROR_STOP and multiple -f switches
- client-side error commits transaction, no ON_ERROR_STOP and multiple -c switches
