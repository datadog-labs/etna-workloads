# first_value_streaming_eligibility_framed_9a691cb1ea

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9a691cb1eaafe1b788c68c85bf592648d7416eac ("Fix FIRST_VALUE streaming eligibility for framed windows"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/window/test_streaming_window.test
