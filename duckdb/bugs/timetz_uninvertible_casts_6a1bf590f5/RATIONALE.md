# timetz_uninvertible_casts_6a1bf590f5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6a1bf590f5fcf9fde6f8d9347bc01d58c6335032 ("Issue #13813: TIMETZ Uninvertible Casts"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/time/test_time_tz_icu.test
