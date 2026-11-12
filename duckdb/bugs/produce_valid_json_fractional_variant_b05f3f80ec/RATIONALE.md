# produce_valid_json_fractional_variant_b05f3f80ec

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b05f3f80ecedea2fc136417b50eabda8fadb55e1 ("Produce valid JSON for fractional VARIANT decimals"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/variant/json_cast.test
