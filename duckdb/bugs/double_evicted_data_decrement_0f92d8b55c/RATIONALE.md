# double_evicted_data_decrement_0f92d8b55c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0f92d8b55c477bc314288fc7e0d8ac8587dba26f ("Fix double evicted data decrement"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/sql/storage/test_buffer_manager.cpp::Test buffer manager buffer re-use
