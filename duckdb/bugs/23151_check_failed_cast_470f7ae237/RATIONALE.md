# 23151_check_failed_cast_470f7ae237

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 470f7ae2370faab4d0cbcc183bea072b547e5997 ("Issue 23151: check for failed cast"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/variant/try_cast_from_variant.test
