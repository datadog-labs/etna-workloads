# if_we_don_t_follow_9d89a8c007

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9d89a8c007bb88da27214cd419b658da75ae717f ("if we don't follow composite key cap we should estimate normally"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/joins/fkpk_composite_key_ce.test
