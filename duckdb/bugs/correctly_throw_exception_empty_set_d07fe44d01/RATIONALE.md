# correctly_throw_exception_empty_set_d07fe44d01

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d07fe44d012ae83fb71ff1656abd973ab0e5f242 ("Correctly throw exception on empty set returned by COLUMNS() expression in WHERE clause"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parser/test_columns_where.test
