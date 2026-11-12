# collation_roundtrip_28dcfe6c8d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 28dcfe6c8d28050d96622813b7c0299ab628d76d ("fix collation roundtrip"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/cast_expression_storage_version.test
