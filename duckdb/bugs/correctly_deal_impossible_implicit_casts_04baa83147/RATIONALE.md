# correctly_deal_impossible_implicit_casts_04baa83147

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 04baa831475b777f978d34cdca80529e8d27a869 ("Correctly deal with impossible implicit casts from array -> list"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/array/array_flatten.test
