# hold_lock_across_live_handle_bf3129aa49

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit bf3129aa49e52e23a40c89e603293d1d5d9a92b6 ("Hold the lock across the live-handle check and free-list transition when unregistering"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_metadata_pin_race.cpp::Stress stale metadata block handle pin against checkpoint rewrite
