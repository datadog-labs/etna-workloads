# do_not_collect_residual_predicates_078e335e10

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 078e335e106ce1e64e921854efe13e0d16e71950 ("do not collect residual predicates owned by must-apply"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/joins/test_must_apply_residual_predicate.test
