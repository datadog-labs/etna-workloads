# handle_infinite_dates_timestamp_comparison_a272e11a7a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a272e11a7ade9b430ef3ddd335842b0d1e7c3f40 ("Handle infinite dates in timestamp comparison optimization"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/pushdown/timestamp_to_date_infinity_pushdown.test
