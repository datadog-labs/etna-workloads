# typed_variant_negative_zero_sql_634f522cae

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 634f522cae7031642193d6382a1220945cbfab08 ("Fix typed VARIANT and negative-zero SQL value rendering"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_value_to_sql_string.cpp::Value::ToSQLString preserves negative floating zero
- cpp:test/common/test_value_to_sql_string.cpp::Value::ToSQLString round-trips JSON-derived supported VARIANT objects
- cpp:test/common/test_value_to_sql_string.cpp::Value::ToSQLString round-trips typed VARIANT payloads
