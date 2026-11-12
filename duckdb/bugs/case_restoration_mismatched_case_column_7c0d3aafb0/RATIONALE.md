# case_restoration_mismatched_case_column_7c0d3aafb0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7c0d3aafb064ce61048faa0c63344b5a723b6659 ("Fix case restoration for mismatched case column references"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/binder/test_case_insensitive_binding.test
