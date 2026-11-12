# partitioned_copy_do_not_count_6714c50b52

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6714c50b52aa0f109212e2915c849cd0be185257 ("Partitioned COPY: do not count rows of the next partition into a ROW_GROUP_SIZE_BYTES batch"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/partitioned/partitioned_row_group_size_bytes_boundary.test
