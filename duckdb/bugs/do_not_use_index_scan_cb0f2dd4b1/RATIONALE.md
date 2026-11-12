# do_not_use_index_scan_cb0f2dd4b1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit cb0f2dd4b184145788391f27ec1d8823d6cbb791 ("Do not use an index scan when a sample was pushed into the table scan"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/sample/system_sample_index_scan.test
