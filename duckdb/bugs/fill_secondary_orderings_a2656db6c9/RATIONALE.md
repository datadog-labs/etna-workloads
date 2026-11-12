# fill_secondary_orderings_a2656db6c9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a2656db6c93d1165fd1b4cf72fb5f64fb8e2c2fe ("Issue #17040: FILL Secondary Orderings"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_fill_orderby.test
