# add_reader_test_6e6bb8eccd

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 6e6bb8eccd07fad986a9c8ff56f4f6969c17c81f ("add reader (deserialize) fix and test"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/optimizer/function_invocation_serialization.cpp::Table function bind data remains readable after removing its serialize callback
