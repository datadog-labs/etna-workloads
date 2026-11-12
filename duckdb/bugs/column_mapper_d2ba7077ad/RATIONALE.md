# column_mapper_d2ba7077ad

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d2ba7077ad157d7ebf59f22479a3026ee0597231 ("fixes to the column mapper"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/parquet/schema_nested_evolution.test
