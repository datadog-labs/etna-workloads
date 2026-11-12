# large_divisor_taking_wrong_path_fb2cb36d3f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fb2cb36d3f697bb0f99eecc1a3cf178adccffcd1 ("Fix for large divisor taking the wrong path"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/decimal/decimal_division.test
