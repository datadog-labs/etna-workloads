# Reproducer notes

`repro.sh` starts a single `valkey-server`, then issues a `RESTORE` with the
same corrupt serialized stream payload used by the upstream test
`tests/integration/corrupt-dump.tcl: corrupt payload: stream with duplicate
consumers`. The payload encodes a stream consumer group containing two
consumers with the same name ("name*" / "name+" collide after the group's
internal normalization), which `rdbLoadObject()` must reject while loading
the RESTORE value.

- On the **clean** build (with the fix), `streamCreateConsumer()` returns
  NULL for the duplicate consumer, `rdbLoadObject()` detects this, logs
  `Duplicate stream consumer detected.`, and aborts the load. The client
  sees `ERR Bad data format`, a later `PING` still succeeds, and the log
  line is observed (`DUPLICATE_LOGGED` printed).

- On the **buggy** build (bug re-injected), the NULL return from
  `streamCreateConsumer()` is dereferenced unchecked
  (`consumer->seen_time = ...`), crashing the server with a segfault. The
  client's connection is dropped mid-command, the subsequent `PING` fails
  to connect, and no `DUPLICATE_LOGGED` line appears.

Running `./check.sh` shows exactly this divergence: identical, deterministic
output on the clean build vs. a dropped connection / connection-refused
output on the buggy build.
