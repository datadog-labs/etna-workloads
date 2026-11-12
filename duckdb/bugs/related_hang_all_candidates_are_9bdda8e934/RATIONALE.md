# related_hang_all_candidates_are_9bdda8e934

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9bdda8e93416df7a25a6adc2652fe32ff804792e ("Fix issue related to hang when all candidates are eliminated in refinement"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/test_sniffer_hang.test
