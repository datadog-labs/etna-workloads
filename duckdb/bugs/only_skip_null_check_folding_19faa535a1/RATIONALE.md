# only_skip_null_check_folding_19faa535a1

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 19faa535a1ad15d99dfa2cf8ce7c6dd7f264fdbd ("Only skip NULL check folding for throwing VARIANT casts"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/null_check_statistics_propagation.test
