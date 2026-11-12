# empty_match_handling_regexp_extract_18a618ae8d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 18a618ae8dad3774a98acd335953e3eba0d262f7 ("Fix empty-match handling in regexp_extract_all, anchoring in string_split_regex, and ILIKE upper-case escape"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/string/test_regex_match_positions.test
