# prevent_volatile_predicates_from_being_833155d1b2

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 833155d1b2e68dc4bdf6b2f1f4da3bf7f7660e9e ("Prevent volatile  predicates from being pushed below window operators"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_24829.test
