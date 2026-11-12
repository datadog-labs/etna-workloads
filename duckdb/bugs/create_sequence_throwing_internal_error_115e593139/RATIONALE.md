# create_sequence_throwing_internal_error_115e593139

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 115e593139967b82764c5452540c955962033438 ("Fix CREATE SEQUENCE throwing INTERNAL error on NULL option values"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/catalog/sequence/test_sequence.test
