# Rationale

Changed: src/backend/utils/adt/genfile.c, `pg_ls_dir()` (plus restoring the `directory_fctx` typedef).

Traces to the genfile.c hunks of fix.patch that converted pg_ls_dir from ValuePerCall mode to a
single-call tuplestore (Materialize) function. Reverting to SRF_FIRSTCALL_INIT/SRF_PERCALL_SETUP
keeps the directory FD open across calls. When the SRF is not run to completion (e.g. with LIMIT:
`select * from (select pg_ls_dir('.') a) a where a = 'base' limit 1`), the DIR is never freed
before the end of the query, so the leak is visible.

Failing oracle cases:
- src/test/regress||misc_functions
