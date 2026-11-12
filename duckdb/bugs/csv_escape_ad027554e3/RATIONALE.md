# csv_escape_ad027554e3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ad027554e3bfde5f617f85c1a7af14dbe3e49f70 ("Fix CSV escape"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/issue_22153.test
