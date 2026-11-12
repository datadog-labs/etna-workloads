# row_number_gaps_vector_sized_b896de12be

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit b896de12be389a3ca227aa31b4b93eccd13f8f5d ("Fix row_number gaps in vector-sized parallel scans"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/row_number_virtual_column.test
