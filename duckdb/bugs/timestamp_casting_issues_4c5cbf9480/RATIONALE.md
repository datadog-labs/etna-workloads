# timestamp_casting_issues_4c5cbf9480

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4c5cbf948053986631a553b558733a1abdad5b5d ("fix timestamp casting issues"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/timestamp_comparisons.test
