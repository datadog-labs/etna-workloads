# reject_filename_hive_partition_collisions_51fcad0c7a

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 51fcad0c7a58eb8baa42898912d6cea90f556824 ("Reject filename and Hive partition collisions"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_24310.test
