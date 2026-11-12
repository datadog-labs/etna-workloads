# skip_deduplication_volatile_aggregates_window_47dfe8f114

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 47dfe8f1147302c3fb25774b9ee789d1698199c2 ("fix: skip deduplication for volatile aggregates and window expressions"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_volatile_independence.test
