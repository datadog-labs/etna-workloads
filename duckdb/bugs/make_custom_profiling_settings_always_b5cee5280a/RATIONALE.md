# make_custom_profiling_settings_always_b5cee5280a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b5cee5280acdef821f9ea74eab8522c2e65f2a91 ("Make custom_profiling_settings always return a list of enabled metrics, instead of returning what was input"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/pragma/profiling/test_custom_profiling_optimizer_settings.test
- test/sql/pragma/profiling/test_empty_profiling_settings.test
