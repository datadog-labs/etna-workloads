# aggregate_spill_transitions_source_hash_87823de433

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 87823de4338a7542ac2114e1624175543e5c07db ("Fix aggregate spill transitions and source hash table cleanup"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_radix_ht_sink.cpp::A reduced reservation does not prevent external aggregation
- cpp:test/common/test_radix_ht_sink.cpp::Finished aggregate sources release their local hash tables
