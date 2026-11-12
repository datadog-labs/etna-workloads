# correctly_handle_failing_member_casts_ec2e719272

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit ec2e719272a89baa91e141067bb6e483f54472a6 ("Correctly handle failing member casts in UNION -> UNION TRY_CAST - always finish writing the tags and unmapped members, set rows whose selected member failed to cast to NULL, and propagate the result of the cast"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/types/union/union_try_cast_member_failure.test
