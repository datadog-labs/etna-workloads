# Rationale

File: src/backend/utils/adt/genfile.c, function pg_ls_dir_files() (plus a local `directory_fctx` typedef, which the original fix had removed from the header/function).

Traces to the single fix_impl.patch hunk set: the fix converted pg_ls_dir_files() from value-per-call SRF mode to a single-call materialize-mode function. I reverted it to the value-per-call form (SRF_FIRSTCALL_INIT / SRF_PERCALL_SETUP / SRF_RETURN_NEXT). The DIR handle is again opened on the first call and kept open in fctx across calls, and FreeDir only runs if the SRF is run to completion. If the query stops early (e.g. LIMIT), the directory FD is left open, which is the bug. The existing ENOENT-on-stat handling is kept.

Failing oracle case: src/test/regress||misc_functions
