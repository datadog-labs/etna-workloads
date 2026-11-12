# increase_fallback_string_cast_cost_3838c4a1ed

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3838c4a1edd83dc1373b6077dc6ee478bb996e50 ("increase fallback string cast cost"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/binder/old_implicit_cast_template.test
