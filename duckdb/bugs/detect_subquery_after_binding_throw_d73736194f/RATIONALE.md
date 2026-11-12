# detect_subquery_after_binding_throw_d73736194f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d73736194fc087f5c0f8270f4a7e6c0df6a1458d ("detect the subquery after binding and throw"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/generated_columns/virtual/create_table.test
