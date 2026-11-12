# initialize_shredded_base_stats_correctly_f9fe685a6c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f9fe685a6ca6d98ea4c0b32ff3b7795f1bee01f7 ("initialize shredded base stats correctly"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/geo/geometry_shred_deletes.test
