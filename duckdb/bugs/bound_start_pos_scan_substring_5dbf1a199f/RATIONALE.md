# bound_start_pos_scan_substring_5dbf1a199f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 5dbf1a199f02098e51f2a7fb9b04832efde9185c ("bound start_pos scan in substring with negative offset"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_substring_oob.cpp::substring negative offset on non-utf8 input stays in bounds
