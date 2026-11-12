# bug_dbd5b76a06

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit dbd5b76a066f32e3e406315f07071506c847ad2f ("fix"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/aggregate/aggregates/arg_min_max_nulls_last_all_types.test_slow
