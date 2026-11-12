# more_tweaks_1580d93e32

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1580d93e32ca831d9b95efe6c3f8908cd2085dc8 ("More tweaks"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/test_cranlogs.test_slow
