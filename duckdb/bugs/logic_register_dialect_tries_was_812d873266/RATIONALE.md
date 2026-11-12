# logic_register_dialect_tries_was_812d873266

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 812d8732663e4d8ac50799e502d814fa5e3746ef ("Logic to register dialect tries was incorrect"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/csv/14874.test
