# support_lossy_uhugeint_conversion_arrow_06e9436b9e

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 06e9436b9efcfc3318efaf32abc49519db9dec03 ("Support lossy UHugeInt conversion to Arrow Decimal iff Arrow extensions are disabled"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/arrow/arrow_roundtrip.cpp::Test Arrow Extension Types
