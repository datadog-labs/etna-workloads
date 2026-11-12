# copy_reject_compression_option_given_5d23227e2b

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 5d23227e2b3d705003fbdd413f9848d5c20e7786 ("COPY (FORMAT BLOB): reject a COMPRESSION option given without a value"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/copy/copy_blob_options.test
