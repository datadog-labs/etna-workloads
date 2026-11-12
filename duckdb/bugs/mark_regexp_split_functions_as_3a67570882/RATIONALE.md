# mark_regexp_split_functions_as_3a67570882

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 3a67570882873bef3bb9734059d68d1f58a58d7e ("Mark regexp split functions as fallible"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/string/test_string_split.test
