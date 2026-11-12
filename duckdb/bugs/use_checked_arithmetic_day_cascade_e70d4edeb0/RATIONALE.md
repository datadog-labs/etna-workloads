# use_checked_arithmetic_day_cascade_e70d4edeb0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e70d4edeb0465f4396529d21cb0bc0aab5c6a647 ("Use checked arithmetic for the day cascade in INTERVAL * double"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/interval/interval_multiply_overflow.test
