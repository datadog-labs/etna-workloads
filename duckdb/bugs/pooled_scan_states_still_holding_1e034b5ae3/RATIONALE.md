# pooled_scan_states_still_holding_1e034b5ae3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1e034b5ae32de308beef6fd7fe8b595bc11630b9 ("fix pooled scan states still holding segment pins after being returned to pool"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/parallelism/intraquery/test_transaction_local_parallelism.test
