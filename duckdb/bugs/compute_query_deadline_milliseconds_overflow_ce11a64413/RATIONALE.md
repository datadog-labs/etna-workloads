# compute_query_deadline_milliseconds_overflow_ce11a64413

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ce11a6441347a7a51e727c4d32bd38fe1070cbf3 ("Compute the query deadline in milliseconds with an overflow check"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/settings/max_execution_time.test
