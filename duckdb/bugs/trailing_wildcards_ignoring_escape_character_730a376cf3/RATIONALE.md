# trailing_wildcards_ignoring_escape_character_730a376cf3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 730a376cf34a5604795bfc6201ac1caf21b98fc1 ("Fix trailing '%' wildcards ignoring the ESCAPE character"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/string/test_like_escape.test
