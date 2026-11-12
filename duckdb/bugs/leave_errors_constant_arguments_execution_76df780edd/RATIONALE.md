# leave_errors_constant_arguments_execution_76df780edd

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 76df780edd59da4de61594306244cc3f5455690e ("Leave errors of constant arguments to execution in the empty-needle and left join rewrites"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/constant_argument_errors.test
