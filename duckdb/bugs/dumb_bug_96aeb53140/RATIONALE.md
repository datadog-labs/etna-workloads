# dumb_bug_96aeb53140

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 96aeb531405ce593484aedd64809d8745cc5f87f ("fixed dumb bug"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/test_relation_api.cpp::Test crossproduct relation
