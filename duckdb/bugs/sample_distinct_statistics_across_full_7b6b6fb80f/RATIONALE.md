# sample_distinct_statistics_across_full_7b6b6fb80f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7b6b6fb80fbd7931943acd854c69d8947fa0ea15 ("Sample distinct statistics across full vectors without slice overhead"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/distinct_statistics_sample.test
