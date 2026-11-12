# crash_casting_union_union_variant_cbe0b2f543

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cbe0b2f5431a39e5b1648a5159c87bcee4fff61e ("Fix crash casting a UNION to a UNION with a VARIANT member"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/union_member_variant_cast.test
