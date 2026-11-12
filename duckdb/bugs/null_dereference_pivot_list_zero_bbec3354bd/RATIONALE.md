# null_dereference_pivot_list_zero_bbec3354bd

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bbec3354bdee247f8e643aa6b15abfaff60d0bb6 ("Fix #26362: Null dereference in PIVOT IN list with zero-argument row()"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/pivot/pivot_errors.test
