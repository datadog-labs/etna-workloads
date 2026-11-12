# storage_leak_after_checkpoint_failure_4660e91e23

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4660e91e230586c7563515511f4dc3c52d607f87 ("Fix storage leak after checkpoint failure"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/checkpoint/test_checkpoint_abort_truncate.test
