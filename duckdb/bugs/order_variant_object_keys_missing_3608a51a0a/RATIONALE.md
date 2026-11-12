# order_variant_object_keys_missing_3608a51a0a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3608a51a0a4ae859d6de14af400d0779a8bc7a8a ("Order VARIANT object keys in the missing key cast error"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/types/variant/variant_object_key_order_shredded.test
- test/sql/types/variant/variant_object_key_order.test
