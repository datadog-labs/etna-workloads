# reuse_buffer_destruction_policy_replaced_f6b49e742c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit f6b49e742cdaf2330b5ed1edf32734621537d8be ("Reuse the buffer destruction policy for replaced handles and tighten the regression tests"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_metadata_pin_race.cpp::Stress stale metadata block handle pin against checkpoint rewrite
