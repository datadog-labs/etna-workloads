# review_comment_scope_global_plus_94ab591189

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 94ab59118979314a365de03002ec9d3e21d6c4ac ("Review comment 'scope=global', plus 3 similar fixes elsewhere"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/storage/external_file_cache/external_file_cache_block_size.test
