# NOTES

`repro.sh` starts a single server, creates a one-field hash (`myhash`)
and a one-member zset (`myzset`), then issues:

    HRANDFIELD myhash -9223372036854770000 WITHVALUES
    ZRANDMEMBER myzset -9223372036854770000 WITHSCORES

Both counts are large negative numbers whose absolute value is close
to `LONG_MAX`. The upstream fix (commit `16f408b1a0121ca...`, CVE-2023-
22458) rejects any `count` outside `[LONG_MIN/2, LONG_MAX/2]` for the
WITHVALUES/WITHSCORES form with `value is out of range`. `injection.patch`
removes exactly that check.

- **Clean build**: both commands return `ERR value is out of range`
  immediately; the server stays responsive (`SERVER_ALIVE`).
- **Buggy build**: the missing check lets `count` through as an
  enormous unsigned magnitude. `hrandfieldWithCountCommand`/
  `zrandmemberWithCountCommand` then try to emit that many (sampled)
  elements in a `while (count--)` loop, which never finishes in
  practice — the single-threaded server becomes permanently
  unresponsive to every client, including the one that sent the
  command. Both calls hit the script's 5s `timeout` and print
  `TIMEOUT`, and the final liveness probe reports `SERVER_DOWN`
  (unresponsive, then killed by the script).

Every client call is wrapped in `timeout 5` so the script finishes in
bounded time regardless of which build it runs against.
