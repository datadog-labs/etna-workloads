# self_referencing_foreign_key_throw_1be6e3974d

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 1be6e3974d02e89f916b922fcaf89d1d514c1dda ("self referencing foreign key throw on export"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/constraints/foreignkey/test_fk_self_reference_export.test
