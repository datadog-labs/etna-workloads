# internal_bind_error_unnest_comma_d2f1a0dbb9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d2f1a0dbb9f40035c344d8d502295d2000459be7 ("Fix INTERNAL bind error for UNNEST comma join with CAST filter"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_25167.test
