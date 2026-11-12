# use_statewithblockabletasks_only_block_current_9161860da1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9161860da1fef524c0bdc74c4659a14d25228763 ("use StateWithBlockableTasks and only block when current is full"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_copy_output_lifecycle.cpp::Partitioned COPY bounds overlapping input and wakes combined producers
