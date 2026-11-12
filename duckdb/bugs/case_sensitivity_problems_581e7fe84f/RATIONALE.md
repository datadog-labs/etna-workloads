# case_sensitivity_problems_581e7fe84f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 581e7fe84f33299ec7ca1243fc50c515cd811abb ("fix case-sensitivity problems"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/parquet/variant/pushdown/variant_case_sensitivity.test
