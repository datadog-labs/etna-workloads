# crash_using_try_within_if_e6213d117a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e6213d117a5cc9b2cc463a3c5f4fdd748ecfdbcb ("Fix crash when using `try` within `if`"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/error/test_try_expression.test_slow
