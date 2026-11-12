# address_review_build_bloom_filter_fecdc84f0f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fecdc84f0f26f483eab2f480193b6fd64b7697bf ("address review: build the bloom filter during Sink only for external joins"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/external/bloom_filter_overestimated_build.test_slow
