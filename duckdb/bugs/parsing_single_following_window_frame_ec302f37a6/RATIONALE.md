# parsing_single_following_window_frame_ec302f37a6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ec302f37a6ce32a7c281c06ccbed501d0a47ddc8 ("Fix parsing of single `FOLLOWING` window frame bounds"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_single_following_frame.test
