# fold_struct_extract_table_subscripts_d7e7a1f790

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d7e7a1f7901cff687cafec236d22bec105ebd4dc ("Fold struct_extract(struct_pack(...)) for table subscripts"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_21492.test
