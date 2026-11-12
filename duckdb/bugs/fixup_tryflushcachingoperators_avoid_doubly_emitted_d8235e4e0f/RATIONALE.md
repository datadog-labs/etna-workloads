# fixup_tryflushcachingoperators_avoid_doubly_emitted_d8235e4e0f

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit d8235e4e0f6e990f3757d0bed06151c2db727efe ("Fixup TryFlushCachingOperators to avoid doubly emitted chunks"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/limit/streaming_limit_pipeline_flush2.test
