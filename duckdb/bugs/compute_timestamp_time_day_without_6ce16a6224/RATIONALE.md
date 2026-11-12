# compute_timestamp_time_day_without_6ce16a6224

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6ce16a622426db705960c8aea4eeb167ebaec4c4 ("Compute a TIMESTAMP time of day without signed overflow"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/timestamp/timestamp_time_of_day_overflow.test
