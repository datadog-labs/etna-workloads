# NOTES

`repro.sh` reproduces the zipmap value-length integer overflow in
`zipmapValidateIntegrity` (fixed by upstream commit `3c634b6972f0`).

It starts a server, enables `debug set-skip-checksum-validation`, then sends
a `RESTORE` with a crafted zipmap payload whose value length is `0xFFFFFFFF`
with a 1-byte free space, so `l + e` wraps to 0 in 32-bit arithmetic (this is
the exact payload from the upstream test). Because the payload contains
embedded NUL bytes, it can't be passed as a `valkey-cli` argv argument (argv
strings are NUL-terminated), so the script speaks RESP directly over
`/dev/tcp/127.0.0.1/$PORT` for just that command.

In both builds `RESTORE` replies `-ERR Bad data format` and the server stays
up (`PING` still returns `PONG`), since on 64-bit the corrupt entry is
eventually rejected one way or another. What differs is *where* it gets
rejected, visible in the server log:

- **clean build**: `zipmapValidateIntegrity` itself rejects the bounds
  violation up front, logging "Zipmap integrity check failed."
- **buggy build**: the validator's bounds check is missing (reverted by
  `injection.patch`), so it wrongly accepts the corrupt payload. The
  corruption is only caught later, during the zipmap-to-listpack conversion,
  when `lpSafeToAdd` rejects the (wrapped-then-recomputed) huge length,
  logging "Hash zipmap with dup elements, or big length (3)" instead.

`repro.sh` greps the log for either message and prints a fixed line, giving
a deterministic pass/fail signal without printing timestamps, pids, or raw
log lines. On 32-bit builds this same validator gap would let `p` wrap and
cause out-of-bounds access instead of being caught downstream.
