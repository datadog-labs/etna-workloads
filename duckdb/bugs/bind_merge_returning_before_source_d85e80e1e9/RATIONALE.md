# bind_merge_returning_before_source_d85e80e1e9

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d85e80e1e93bbab39cc08ae9f95e8b411ced2b90 ("Bind MERGE RETURNING before source actions"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/issues/general/test_24212.test
