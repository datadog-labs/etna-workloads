# variant_selection_vector_index_6b5327597f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6b5327597fe6e6b84445168b961ed0289f9439b3 ("Fix variant selection vector index"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/variant/variant_extract.test
