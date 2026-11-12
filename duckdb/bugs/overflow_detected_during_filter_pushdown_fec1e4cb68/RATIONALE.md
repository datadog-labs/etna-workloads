# overflow_detected_during_filter_pushdown_fec1e4cb68

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fec1e4cb689b236c3271340fd9be6d8f9caffdc5 ("Fix #9806 - when an overflow is detected during filter pushdown the pushdown should be halted, instead of claiming the result is always false (which is not the case)"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/rigger/overflow_filter_pushdown.test
