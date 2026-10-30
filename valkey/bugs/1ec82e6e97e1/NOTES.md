# Reproducer notes

`repro.sh` targets the `checkStringLength()` regression introduced by
`injection.patch` (the inverse of the 2023-01-16 fix), exercised by the
`tests/unit/type/string.tcl` test "SETRANGE with huge offset".

It starts a single server, then issues:

    SETRANGE K 9223372036854775807 A

On the **clean** build, `checkStringLength(c, offset, sdslen(value))` widens
`offset + append` to `uint64_t` before comparing it against
`proto-max-bulk-len`, so the overflow is detected and the command is
rejected cleanly:

    ERR string exceeds maximum allowed size (proto-max-bulk-len)

and a subsequent PING still succeeds.

On the **buggy** build, the caller computes `offset + sdslen(value)` as a
plain signed `long long` *before* calling `checkStringLength()`. This
overflows (UB, wraps to a negative value), sails past the
`size > server.proto_max_bulk_len` check, and the resulting (effectively
huge, since it's later used via `sdsnewlen`/`sdsgrowzero`) allocation size
crashes the server. The script detects this two ways: the `SETRANGE` reply
becomes "Server closed the connection" instead of an error reply, the
follow-up PING fails to connect, and the server log contains the crash
report banner, so the script prints `CRASHED`.

Running `./check.sh` shows the clean build printing the proto-max-bulk-len
error and `PONG`, while the buggy build prints a connection-closed error,
a failed PING, and `CRASHED`.
