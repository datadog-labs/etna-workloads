# rebind_prepared_currval_its_sequence_d1054e9769

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d1054e97690a218ec001d0a1d7ea1398502e23c4 ("Rebind a prepared currval() when its sequence changes"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/catalog/sequence/prepared_currval_dropped_sequence.test
