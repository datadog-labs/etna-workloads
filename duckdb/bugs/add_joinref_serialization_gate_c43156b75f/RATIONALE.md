# add_joinref_serialization_gate_c43156b75f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit c43156b75fb6abd57b148babc67f43c20765308a ("add joinref serialization gate"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/join/nearest/nearest_storage.test
