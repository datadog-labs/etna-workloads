# list_position_statistics_propagation_null_c9ce6bbf63

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c9ce6bbf6357dfd52cb0742245852680b581b68f ("Fix list_position statistics propagation for a NULL needle"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/function/list/list_position_null_needle.test
