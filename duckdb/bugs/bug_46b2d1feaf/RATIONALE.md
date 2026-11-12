# bug_46b2d1feaf

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 46b2d1feafb07504903e461ecd17d237e415f4f1 ("fixes"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/variant_shredded_extract_wrong_type.test
