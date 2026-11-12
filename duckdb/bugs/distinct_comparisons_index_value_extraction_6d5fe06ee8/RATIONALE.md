# distinct_comparisons_index_value_extraction_6d5fe06ee8

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6d5fe06ee83a1ae7b0e8695f8a91d11a7bde6d97 ("Fix distinct comparisons in index value extraction"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/index/art/issues/test_art_issue_25155.test
