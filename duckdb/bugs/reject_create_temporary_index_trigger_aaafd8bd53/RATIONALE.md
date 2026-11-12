# reject_create_temporary_index_trigger_aaafd8bd53

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit aaafd8bd532bd3bcf7fb1e2177a2bc12be645f9a ("Reject CREATE TEMPORARY INDEX / TRIGGER, inherit trigger temporariness"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/catalog/test_temporary_index.test
- test/sql/trigger/temporary_trigger.test
