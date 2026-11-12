# make_like_matching_iterative_avoid_c0f1365626

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c0f136562641eda6ad0b48383dd2893a687dd88d ("Make LIKE matching iterative to avoid stack overflow with many wildcards"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/string/test_like_many_wildcards.test
