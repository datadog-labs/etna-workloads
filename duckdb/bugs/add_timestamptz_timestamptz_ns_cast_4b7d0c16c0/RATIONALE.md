# add_timestamptz_timestamptz_ns_cast_4b7d0c16c0

Verbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of upstream commit 4b7d0c16c0f18f85d203eead25c20f4701836ec5 ("Add TIMESTAMPTZ to TIMESTAMPTZ_NS cast"), applied to DuckDB v2.0.0 (clean). No hunk was written by hand or by an agent.

Failing oracle cases (failed in both injected runs, passed in both base runs):
- test/sql/cast/timestamp_casts.test
