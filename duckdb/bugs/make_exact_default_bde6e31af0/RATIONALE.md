# make_exact_default_bde6e31af0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bde6e31af0ecf28a5f5e27baaee336648fa6f59e ("make exact default"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/nearest/nearest_storage.test
