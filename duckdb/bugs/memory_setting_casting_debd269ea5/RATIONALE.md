# memory_setting_casting_debd269ea5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit debd269ea583790d8b670efc779c686ebac37615 ("Fix memory setting casting"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/settings/max_memory_percentage.test
