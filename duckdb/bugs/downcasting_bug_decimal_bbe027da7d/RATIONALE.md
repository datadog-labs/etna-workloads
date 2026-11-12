# downcasting_bug_decimal_bbe027da7d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bbe027da7d10d542e831df9ad5cb291059860ecd ("Fix downcasting bug for decimal"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/decimal_cast.test
