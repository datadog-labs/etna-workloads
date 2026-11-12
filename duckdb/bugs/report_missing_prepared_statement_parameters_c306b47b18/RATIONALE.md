# report_missing_prepared_statement_parameters_c306b47b18

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c306b47b18095823f22774a972e7cda1170f87a0 (""Report missing prepared statement parameters in declaration order"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/prepared/prepared_named_param.test
