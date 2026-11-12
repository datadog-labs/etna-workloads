# consider_casts_from_floating_point_b9e9a3bf30

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b9e9a3bf30768925a66d0f14bb8afe73e7814cf4 ("Consider casts from floating point values to BIGNUM as casts that can fail"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/bignum/test_bignum_from_non_finite.test
