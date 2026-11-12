# signed_integer_overflow_timestamp_difference_3e926ddaba

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3e926ddaba99b5ba3b131e8c7f064640f247ab77 ("Fix signed integer overflow in timestamp difference"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/sqlsmith/timestamp_diff_overflow.test
