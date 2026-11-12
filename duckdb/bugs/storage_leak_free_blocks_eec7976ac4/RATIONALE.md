# storage_leak_free_blocks_eec7976ac4

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit eec7976ac452491408d85dfb0c8f178147265fba ("Fix storage leak for free blocks"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/checkpoint_free_blocks_in_use.test_slow
