# time_ns_read_write_parquet_c858ea45b6

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c858ea45b63f79ebc952f861cb23e8bd3dd8e515 ("Fix TIME_NS read/write with parquet (#23958)"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/parquet/timens_parquet.test
- test/sql/types/time/test_time_ns.test
