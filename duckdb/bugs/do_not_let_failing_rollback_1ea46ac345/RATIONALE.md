# do_not_let_failing_rollback_1ea46ac345

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1ea46ac345b9bbe2fb8ac8289ec22e58106bef08 ("Do not let a failing rollback escape ClientContext's destructor"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_lifecycle_hooks.cpp::Dropping a connection whose rollback fails does not terminate
