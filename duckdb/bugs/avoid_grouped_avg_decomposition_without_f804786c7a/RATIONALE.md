# avoid_grouped_avg_decomposition_without_f804786c7a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f804786c7abfb065ceb2f4bf85b39846123eb472 ("Avoid grouped AVG decomposition without reusable aggregate states"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/avg_rewrite_profitability.test
