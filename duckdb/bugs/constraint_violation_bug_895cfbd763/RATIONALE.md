# constraint_violation_bug_895cfbd763

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 895cfbd763146eb63eed35bcc8ef40089dab65ac ("constraint violation bug fix"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/constraints/foreignkey/fk_19469.test
