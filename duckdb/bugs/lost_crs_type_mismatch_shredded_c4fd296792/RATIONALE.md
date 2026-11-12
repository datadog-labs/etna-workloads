# lost_crs_type_mismatch_shredded_c4fd296792

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c4fd2967926506aebaebc826836a55471588a571 ("fix lost crs and type mismatch on shredded geo column"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/geo/geometry_crs_persist.test
