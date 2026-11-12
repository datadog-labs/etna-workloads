# column_projection_struct_pushdown_extract_df81638dbc

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit df81638dbc415a564ae882ebc7cfd7b42479b386 ("Fix column projection when struct pushdown-extract filters cannot be re-pushed"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/late_materialization_pushdown_extract.test
