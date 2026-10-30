# Repro notes

`injection.patch` removes the `minlen = 0;` reset in `bitopCommand()` for
the case where a source key does not exist. `minlen` drives the fast,
word-at-a-time path in `BITOP` (AND/OR/XOR), which reads `minlen` bytes
out of *every* source buffer assuming they are all at least that long.
When a later key is missing, `len[j]` is correctly set to 0 for it, but
without the `minlen = 0` reset, `minlen` can remain at the length computed
from an earlier, existing key. The fast path then reads past the end of
the (zero-length / nonexistent) source buffer, corrupting memory.

`repro.sh`:
- Starts a single server on `$PORT`.
- Sets key `s` to a 40-byte string (long enough to enter the fast,
  `sizeof(unsigned long) * 4`-byte-chunk path in `bitopCommand()`).
- Runs `BITOP OR x s nokey` and `BITOP AND y s nokey`, where `nokey` does
  not exist, then reports `STRLEN` of both results.
- Shuts the server down with `SHUTDOWN NOSAVE` and reports a fixed
  `CRASH` line if the log shows the server died from a signal.

Observed difference:
- **Clean build (9.0.7, fixed)**: both `BITOP` calls succeed, returning
  `40` (the destination length), and the server shuts down cleanly — no
  `CRASH` line.
- **Buggy build (injection.patch applied)**: the server segfaults while
  executing the first `BITOP OR`; the CLI reports a connection failure
  for every subsequent command, and the log-derived `CRASH` line is
  printed.
