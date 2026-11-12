# return_empty_string_substringgrapheme_grapheme_c0871d77c8

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c0871d77c8e0922b6d2c622891e1cd58c8452780 ("Return empty string in SubstringGrapheme when the grapheme bounds are empty"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/string/test_substring_utf8.test
