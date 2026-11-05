# Rationale

File: src/backend/commands/vacuum.c, function ExecVacuum (all hunks trace to the single hunk set in fix_impl.patch).

1. Re-added `bool parallel_option = false;` (fix hunk 1 reversed).
2. In the "parallel" option branch, re-added `parallel_option = true;` (fix hunk 2 reversed).
3. The FULL check again tests `parallel_option` instead of `params.nworkers > 0`, and the message is again
   "cannot specify both FULL and PARALLEL options" (fix hunk 3 reversed).

Effect: any mention of PARALLEL together with FULL (e.g. `VACUUM (FULL, PARALLEL 0)`) is rejected, even though
PARALLEL 0 means parallelism is disabled; and the error message differs from the expected one.

Failing oracle case: src/test/regress||vacuum
