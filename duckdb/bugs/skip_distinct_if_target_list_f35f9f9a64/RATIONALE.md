# skip_distinct_if_target_list_f35f9f9a64

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f35f9f9a643845e8072b6d63756c57d3cdfe861c ("Fix #15199: skip DISTINCT ON if the target list has been emptied (because all targets are literals)"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/public/distinct_on_non_integer_literal.test
