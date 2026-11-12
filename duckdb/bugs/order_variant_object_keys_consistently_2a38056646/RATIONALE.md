# order_variant_object_keys_consistently_2a38056646

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 2a3805664607f999d786b6d6a7c32779c5c0c983 ("Order VARIANT object keys consistently in typeof and the text and JSON casts"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/variant/variant_typeof.test
- test/sql/storage/types/variant/variant_object_key_order_shredded.test
- test/sql/storage/types/variant/variant_object_key_order_shredded_json.test
- test/sql/types/variant/json_cast.test
- test/sql/types/variant/test_all_types.test
- test/sql/types/variant/variant_object_key_order.test
- test/sql/types/variant/variant_object_key_order_json.test
