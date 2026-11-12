# handle_blocks_no_rows_correctly_5b7f6f1779

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 5b7f6f1779d543fb1383b7974b184f3dfc42ae4b ("Handle blocks with no rows correctly. Fixes #22352"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_window_finalize_race.test
