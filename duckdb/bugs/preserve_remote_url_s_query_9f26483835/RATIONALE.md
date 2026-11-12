# preserve_remote_url_s_query_9f26483835

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 9f264838354b46e0fb59677947caed5f72d03ea6 ("Preserve a remote URL's query string in FileSystem::JoinPath"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- cpp:test/common/test_file_system.cpp::JoinPath keeps a remote URL's query string at the end of the path
