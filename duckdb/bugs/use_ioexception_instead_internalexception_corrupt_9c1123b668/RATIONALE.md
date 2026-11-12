# use_ioexception_instead_internalexception_corrupt_9c1123b668

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9c1123b66880d2079957296c9d57b3dc583cdec9 ("Use IOException instead of InternalException for corrupt roaring segment"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/compression/roaring/roaring_corrupted_file.test
