# double_decrement_evicted_data_per_7a080764b6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7a080764b62fc023f8bada17fd6f725ba8bb48f3 ("Fix double decrement of evicted_data_per_tag in .block read-back"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/outofcore/block_file_evicted_bytes_accounting.test_slow
