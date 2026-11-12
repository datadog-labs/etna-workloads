# restore_pre_empty_blob_tolerance_72d283570b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 72d283570bf2501ce68dd86d5cdf03866cadd486 ("Restore pre-fix empty-blob tolerance in AnalyzeWKB"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/geo/geometry_wkb.test
