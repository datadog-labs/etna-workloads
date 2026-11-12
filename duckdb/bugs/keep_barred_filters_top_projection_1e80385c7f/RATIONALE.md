# keep_barred_filters_top_projection_1e80385c7f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1e80385c7f4b6dca02cf14fcb9d42ce2c9d52fc2 ("Keep barred filters on top of a projection when another filter stays there"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/secure_view_pushdown.test
