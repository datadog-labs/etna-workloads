# update_error_message_since_it_bc02ebd43f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bc02ebd43fefdbc7d322d05c4dee2151b950b987 ("Update error message since it is not strictly only for prepared statements"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/index/index_key.test
- test/sql/types/map/map_empty.test
