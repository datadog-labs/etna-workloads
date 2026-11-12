# avoid_deduplicating_union_twice_453123315e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 453123315ee519a663a6a3b48bce12f66fa09ee4 ("Avoid deduplicating UNION twice"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/setops/union_single_dedup.test
