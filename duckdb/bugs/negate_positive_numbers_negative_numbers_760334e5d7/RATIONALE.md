# negate_positive_numbers_negative_numbers_760334e5d7

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 760334e5d752e08588bd4f115307874662d55c0c ("Fix #4674: negate positive numbers to negative numbers instead of the other way around to avoid overflows"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/fuzzer/pedro/overflow_parsing_interval.test
