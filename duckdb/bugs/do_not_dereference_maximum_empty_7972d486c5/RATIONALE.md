# do_not_dereference_maximum_empty_7972d486c5

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7972d486c5f97d64f11b75df9449cab20eb78cd3 ("Do not dereference the maximum of an empty selection buffer when finalizing a dictionary segment"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/compression/dictionary/dictionary_empty_segment.test
