# adding_properly_pass_timestamp_time_de9b8dfc40

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit de9b8dfc401c7ce647b55de7ed22e6bf7d084526 ("Adding Fix to properly  pass timestamp/time formats in the relational API for CSV Files"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_relation_api.cpp::Test CSV reading from weather.csv
