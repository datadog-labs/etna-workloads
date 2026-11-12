# construct_single_member_union_values_244b392016

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 244b392016222325580237ad45a8e0c2d839ef02 ("Construct single-member UNION values with nested type metadata"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/sql_export/union_type_witness.test
