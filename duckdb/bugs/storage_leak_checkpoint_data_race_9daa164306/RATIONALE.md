# storage_leak_checkpoint_data_race_9daa164306

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9daa1643065497f0f2987bd1c7b416048da99721 ("Fix storage leak on checkpoint data race"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/checkpoint_block_count.test_slow
