# honor_record_batch_validity_bitmap_921913f47c

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 921913f47cb7a8a50a9b3fc1de37bf6a58c0d2fc ("Honor the record-batch validity bitmap in the v2 Arrow importer"), applied to DuckDB v2.0.0 (fuzzy). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/api/capi/v2/test_capi_v2_arrow.cpp::V2 arrow: a top-level struct array's own validity bitmap is honored
