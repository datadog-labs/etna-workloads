# consider_geometry_geometry_casts_as_ce1096f538

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ce1096f53851dbd5b403cb89fc08abd6351f38ca ("Consider GEOMETRY to GEOMETRY casts as casts that cannot fail"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/geo/geometry_parquet_pushdown.test
