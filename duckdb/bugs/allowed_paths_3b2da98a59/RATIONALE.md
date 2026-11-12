# allowed_paths_3b2da98a59

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3b2da98a5914d741bdf1e7b026c6ea3cc2748442 ("fix issue with allowed paths"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/settings/allowed_directories.test
