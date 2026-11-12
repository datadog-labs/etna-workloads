# huge_nested_payload_working_properly_fc34b55428

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit fc34b554284525a98b6a1e5b08bb2fa9f164c48b ("huge nested payload working properly with dictionary vector verification now"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/test_huge_nested_payloads.test_slow
