# skip_rewrites_volatile_or_throwing_ff525cc7fb

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ff525cc7fb7630dc068b6b1b6832fcfaf883772a ("Skip rewrites of volatile or throwing expressions"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/optimizer/not_conjunction_simplification.test
