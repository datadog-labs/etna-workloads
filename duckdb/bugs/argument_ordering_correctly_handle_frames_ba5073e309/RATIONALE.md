# argument_ordering_correctly_handle_frames_ba5073e309

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ba5073e3097c5302b5f882d2700aaac1e52c6878 ("Fix  with argument ordering to correctly handle frames that exclude the current row"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_24828.test
