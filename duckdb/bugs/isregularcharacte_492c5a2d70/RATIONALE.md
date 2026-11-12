# isregularcharacte_492c5a2d70

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 492c5a2d70da657b1ca4e56e80695474fd73f705 ("Fix IsRegularCharacte"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/blob/test_blob.test
