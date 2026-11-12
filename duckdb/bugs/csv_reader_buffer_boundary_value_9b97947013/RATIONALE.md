# csv_reader_buffer_boundary_value_9b97947013

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9b97947013af65079dc7df088d8805dd967bf70f ("Fix for CSV reader buffer-boundary value read"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/code_cov/csv_exact_buffer_size.test
