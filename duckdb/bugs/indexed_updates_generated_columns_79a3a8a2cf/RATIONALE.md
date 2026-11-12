# indexed_updates_generated_columns_79a3a8a2cf

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 79a3a8a2cf6329fea79fffa50f09375b9085576a ("Fix indexed updates with generated columns"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/generated_columns/virtual/update_index.test
