# Bug
`process.report.getReport()` with `excludeNetwork = true` still performed reverse-DNS lookups (uv_getnameinfo) for libuv TCP/UDP handle endpoints, because the libuv handle walk ignored the exclude-network setting.

# Change
Single hunk in `src/node_report.cc` (corresponds to the fix's hunk in `WriteNodeReport`): `uv_walk` now always uses `WalkHandleNetwork` instead of `exclude_network ? WalkHandleNoNetwork : WalkHandleNetwork`. Endpoints therefore always get DNS queries, as before the fix (where a single WalkHandle always did them). The other fix hunks (ip4/ip6 fields, plumbing of the flag) are left in place as the plain reversal is not applicable to today's code; they become inert.

# Failing test
`report/test-report-exclude-network`: with excludeNetwork=true the TCP endpoint `host` is the reverse-DNS name (e.g. `localhost`) rather than `127.0.0.1`, so the new "should not do DNS queries in libuv if exclude network" assertion fails.
