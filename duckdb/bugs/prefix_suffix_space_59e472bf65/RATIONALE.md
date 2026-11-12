# prefix_suffix_space_59e472bf65

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 59e472bf650706eca70abe4843b8574d3f4059dc ("prefix/suffix space"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/auto/test_large_integer_detection.test
