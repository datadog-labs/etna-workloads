# restore_validity_referencing_non_null_a5766425b6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a5766425b6a44f6681ca4d66aceb9173b7e0c03c ("Restore validity when referencing a non-NULL list"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/list/list_constant_reference.test
