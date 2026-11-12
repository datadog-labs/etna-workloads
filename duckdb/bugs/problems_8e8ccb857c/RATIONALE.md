# problems_8e8ccb857c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 8e8ccb857ce9b657b187efacf630a52b9d79c212 ("fix problems"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/catalog/dependencies/test_set_default_sequence_dependency.test
