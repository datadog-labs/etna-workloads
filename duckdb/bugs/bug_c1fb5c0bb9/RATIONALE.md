# bug_c1fb5c0bb9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c1fb5c0bb9e44684acba4fdbd99c7f8e3459d21f ("fix"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/statistics/string_expression_filter_pruning.test
