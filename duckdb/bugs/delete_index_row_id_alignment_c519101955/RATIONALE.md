# delete_index_row_id_alignment_c519101955

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c51910195501c3724a491ce5d67403772c90cd10 ("Fix delete index row ID alignment after deduplication"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/delete/test_delete_indexed.test
