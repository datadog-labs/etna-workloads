# empty_ranges_86bc18eb45

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 86bc18eb45b7721e7a53c9e64afb63f47b185614 ("Fix issue with empty ranges"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/list/generate_series.test
