# fractional_second_padding_2911d456d9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 2911d456d9f5e52c8326fbad8071b59faf29f15e ("Issue #17537: Fractional Second Padding"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/timestamp/test_strptime.test
