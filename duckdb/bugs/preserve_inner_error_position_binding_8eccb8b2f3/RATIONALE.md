# preserve_inner_error_position_binding_8eccb8b2f3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8eccb8b2f379174800289eac940fdfb4aef0a25b ("preserve inner error position when binding json_execute_serialized_sql"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/error/error_position_json_execute.test
