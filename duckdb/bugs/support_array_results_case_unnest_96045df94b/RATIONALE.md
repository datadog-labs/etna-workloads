# support_array_results_case_unnest_96045df94b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 96045df94ba90dee4dfb5b9b012d13f01a0245d6 ("Support ARRAY results in CASE, and fix UNNEST of a NULL struct"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/nested/array/array_case.test
- test/sql/types/struct/unnest_struct.test
