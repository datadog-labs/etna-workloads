# error_empty_wkb_e8151ff453

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e8151ff453a180ea4418b36e7069e2bade8d18e1 ("error on empty wkb"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/geo/geometry_wkb.test
