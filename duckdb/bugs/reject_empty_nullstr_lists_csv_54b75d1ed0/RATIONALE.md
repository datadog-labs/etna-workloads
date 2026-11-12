# reject_empty_nullstr_lists_csv_54b75d1ed0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 54b75d1ed04a2f6c807e1587873b123e26294a56 ("Reject empty NULLSTR lists in CSV writer"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/csv_nullstr_list.test
