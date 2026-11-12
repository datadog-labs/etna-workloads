# assertion_varchar_map_try_cast_f551d5f626

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f551d5f626d192441a7ec275354636801c949333 ("Fix assertion in VARCHAR to MAP TRY_CAST with null keys or missing values"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/string_to_map_invalid_entries.test
