Reproducer: enables `save "900 1"`, makes a bgsave fail (child killed with SIGKILL) so writes are
refused with -MISCONF, then pipelines `SET`, `PING`, `PING` over one connection.

Clean: each write/ping gets a well-formed `-MISCONF ...` error reply.
Buggy: the MISCONF error carries an extra `\r\n`, so the stream desyncs and valkey-cli reports
`Protocol error, got "\r" as reply type byte`.
