# sequence_operator_failure_8de20aec8b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8de20aec8bfdc4f3b8d6089f57d4260c7df328c5 ("fix sequence-operator failure"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/execution/physical_verify_vector.test
