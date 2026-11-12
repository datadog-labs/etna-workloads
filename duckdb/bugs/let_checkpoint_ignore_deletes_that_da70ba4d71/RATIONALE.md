# let_checkpoint_ignore_deletes_that_da70ba4d71

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit da70ba4d714dae37d4fc63c407c78d5c4a2d9bd3 ("Let a checkpoint ignore deletes that committed above its bound"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/concurrent_checkpoint_unchanged_table_delete_blocks.test_slow
