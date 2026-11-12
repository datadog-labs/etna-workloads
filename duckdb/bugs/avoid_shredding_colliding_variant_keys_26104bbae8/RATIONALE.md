# avoid_shredding_colliding_variant_keys_26104bbae8

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 26104bbae884c1eed7805c0d6205a7600b3f7ae8 ("Avoid shredding colliding VARIANT keys"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_24298.test
