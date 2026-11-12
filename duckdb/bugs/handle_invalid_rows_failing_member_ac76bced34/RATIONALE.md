# handle_invalid_rows_failing_member_ac76bced34

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ac76bced344103cc58a312387a11b5702ca729ba ("Handle invalid rows and failing member casts in TRY_CAST from STRUCT to UNION"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/union/struct_to_union_try_cast.test
