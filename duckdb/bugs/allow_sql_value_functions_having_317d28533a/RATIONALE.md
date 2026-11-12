# allow_sql_value_functions_having_317d28533a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 317d28533aeeb37853366ca0f50cc1d9f11a6bdc ("Fix #12646 - allow SQL value functions in HAVING"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/test_value_functions.test
