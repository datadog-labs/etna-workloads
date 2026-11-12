# preserve_regex_semantics_collated_strings_0d2bbe18a3

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 0d2bbe18a318f9022e0f21da3cee9b3b685a4177 ("Preserve regex semantics for collated strings"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_24245.test
