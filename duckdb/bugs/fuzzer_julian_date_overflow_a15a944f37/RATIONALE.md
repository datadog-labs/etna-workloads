# fuzzer_julian_date_overflow_a15a944f37

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit a15a944f373407e247cb8bd7409b4b64f5bb393a ("Fuzzer #838: Julian DATE Overflow"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/duckfuzz/julian_overflow.test
