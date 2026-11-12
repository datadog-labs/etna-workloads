# make_blob_bit_cast_try_36a6681240

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 36a66812403067d45a027a69ba23f91f23eeb54e ("Make the BLOB to BIT cast a try-cast so TRY_CAST returns NULL on an empty BLOB"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/try_cast_blob_to_bit.test
