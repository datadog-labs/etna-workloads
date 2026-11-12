# stop_propagating_json_string_bounds_c0ab94172a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c0ab94172a795058a28c76f6e0b7a67ab847da18 ("Stop propagating JSON string bounds through a cast to VARIANT"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/variant/variant_cast_stats_json.test
