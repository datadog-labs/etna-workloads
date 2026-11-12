# early_out_readers_files_that_c5a54a53ee

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c5a54a53ee930f89e1ba1c468c1d82d328c06183 ("Early-out on readers of files that do not have data"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/test_union_by_name.test
