# icu_date_addition_1a66eaa756

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1a66eaa7564f16d6765158df124d34d151407065 ("Issue #561: ICU date addition"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/timestamp/test_icu_dateadd.test
