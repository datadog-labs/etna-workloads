# Reproducer notes

`repro.sh` starts a valkey-server, then opens a raw TCP connection and writes
the pipelined bytes `*0\r\nPING\r\n` immediately followed by `PING\r\n` (inline
command). This is the zero-length multibulk regression from
`tests/unit/protocol.tcl`: a `*0\r\n` multibulk header is a no-op request,
and the server must not get confused about the request type of the command
that follows it in the same read.

- Clean build (fix present): the empty multibulk is ignored and the
  following `PING` is parsed and answered normally: two `+PONG` replies are
  read off the raw socket, and a subsequent `PING` via valkey-cli also
  returns `PONG`.
- Buggy build (injection.patch applied, fix reverted): after the `*0\r\n`
  multibulk is handled, the client's leftover request type is not reset, so
  the parser misinterprets the following `PING\r\n` as multibulk/bulk data.
  This crashes the server (observed as `Aborted (core dumped)` plus a reset
  connection); the subsequent `valkey-cli ping` then fails with
  "Could not connect ... Connection refused".

Verified with `./check.sh`: clean build exits 0 and prints `PONG` three
times; buggy build aborts (core dump) and the final CLI ping is refused.
