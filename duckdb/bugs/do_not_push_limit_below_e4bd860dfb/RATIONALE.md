# do_not_push_limit_below_e4bd860dfb

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit e4bd860dfb97551beaedd4fd44cf68f63fafd844 ("do not push LIMIT below a projection with a volatile expression when an offset is present"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/optimizer/limit_pushdown.test
