# bug_f71422e883

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f71422e883621b25d6b14c7df4f4149bd2cb20a4 ("Fix #22938"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/json/test_json_serialize_sql.test
