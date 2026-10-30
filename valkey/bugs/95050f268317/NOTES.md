# NOTES

`repro.sh` starts a server, enables `debug set-skip-checksum-validation`,
and sends a crafted RDB stream payload (type `RDB_TYPE_STREAM_LISTPACKS_3`)
via `RESTORE _tomb_stream 0 <payload>`. The payload's listpack contains only
tombstone entries, but its `length` field claims there is one valid entry —
exactly the case described in the upstream fix (commit 95050f2683, "solve
corrupt dump fuzzer crash in streams") and in the sibling check this repo's
tree already carries ("stream length inconsistent with valid entries").

The binary payload is written with `printf` straight to `payload.bin`
(so embedded NUL bytes survive) and fed to `valkey-cli -x` as a single
binary-safe argument, since a shell variable would truncate at the first
NUL byte.

After the RESTORE, the script issues `XSETID _tomb_stream 1-1` and then
`PING`, and checks the server log for a panic message.

- **Clean build**: `rdbLoadObject()` rejects the payload at load time
  (`s->length != valid_entries`), so RESTORE replies with a "Bad data
  format" error, the key is never created, XSETID replies "ERR no such
  key", and PING still works.
- **Buggy build** (`injection.patch` removes that length/valid-entries
  check, along with the `s->length && !raxSize(s->rax)` check): RESTORE
  succeeds and loads the corrupt stream object. The subsequent XSETID
  calls `streamLastValidID()`, which finds no valid entry in the
  all-tombstone listpack while `s->length` is nonzero, and hits
  `serverPanic("Corrupt stream, length is %llu, but no max id")`. The
  server aborts (`use-exit-on-panic yes`), so XSETID gets "Server closed
  the connection", the following PING can't connect, and the log
  contains the panic message.

`check.sh` confirms the two builds diverge on every one of these points
while the clean build's output stays fully deterministic.
