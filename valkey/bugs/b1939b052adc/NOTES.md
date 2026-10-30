# NOTES

`repro.sh` starts a single valkey-server, then calls `HRANDFIELD`, `SRANDMEMBER`
and `ZRANDMEMBER` with `count = -9223372036854775808` (`LONG_MIN`) against a
one-element hash/set/zset, in both the plain and `withvalues`/`withscores`
forms, and finally pings and shuts the server down.

This reverts the fix for CVE-2023-25155: the count argument is parsed with
`getLongFromObjectOrReply` (full `long` range) instead of
`getRangeLongFromObjectOrReply(..., -LONG_MAX, LONG_MAX, ...)`, so `LONG_MIN`
is accepted. The commands then negate the count (`-l`) to get an unsigned
element count; negating `LONG_MIN` is undefined behaviour / does not fit in a
`long`, which on the buggy build drives the random-member selection loop into
an effectively infinite loop instead of ever returning a reply.

- Clean build: every command replies immediately. `getRangeLongFromObjectOrReply`
  rejects `LONG_MIN` outright (it is outside `[-LONG_MAX, LONG_MAX]`), so all
  six `HRANDFIELD`/`SRANDMEMBER`/`ZRANDMEMBER` calls reply with
  `(error) ERR value is out of range, value must between ...`. The subsequent
  `PING` returns `PONG` and the server shuts down cleanly — exit status 0.
- Buggy build: the first `HRANDFIELD myhash -9223372036854775808` call never
  returns a reply; the server accepts the SIGTERM sent at shutdown time but
  cannot act on it because it is stuck in the command handler, so the
  `valkey-cli` calls and the final `shutdown` hang. `check.sh` observes this
  as a timeout (no further output after the initial `OK` from `HMSET`),
  which differs from the clean build's full, deterministic transcript.
