# foreign_key_self_reference_sql_c18af5ad3c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c18af5ad3cd875ec3d24152862a1ecba788fabde ("Fix foreign key self-reference SQL"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/constraints/foreignkey/fk_self_reference_tostring.test
