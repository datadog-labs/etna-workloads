# preserve_signed_zero_parquet_dictionaries_099dca8995

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 099dca89953897821713ab85912daa5911e8fdd1 ("fix: preserve signed zero in Parquet dictionaries"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/parquet/parquet_signed_zero.test
