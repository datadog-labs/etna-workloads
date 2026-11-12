# improper_assertion_optimistic_write_92e137e8a9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 92e137e8a962b944c7bda8022510af9cee5d3f51 ("Fix improper assertion for optimistic write"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/optimistic_write/optimistic_write_batch_insert_sub_rowgroup.test
