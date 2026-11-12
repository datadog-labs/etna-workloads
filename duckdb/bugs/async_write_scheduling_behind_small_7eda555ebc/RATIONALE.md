# async_write_scheduling_behind_small_7eda555ebc

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 7eda555ebca28d5889bfe8f2990ee4f57fef6a43 ("Fix async write scheduling behind small prefixes"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_async_file_writer.cpp::AsyncFileWriter schedules a large remote write behind a small prefix
- cpp:test/common/test_async_file_writer.cpp::AsyncWriteQueue schedules a small prefix before a large pending request
