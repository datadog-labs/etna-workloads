# Reproducer notes

`repro.sh` starts a single server, enables `debug set-skip-checksum-validation 1`
(so the checksum on the crafted RDB payload below doesn't need to be faked),
then sends a `RESTORE` for key `_setbig` using the exact corrupted listpack-set
payload from the upstream test `tests/integration/corrupt-dump.tcl`
("corrupt payload: fuzzer findings - leak in rdbloading due to dup entry in
set"). That payload encodes a set with a duplicate member. It then checks
`EXISTS _setbig` and `SCARD _setbig` and shuts the server down.

- Clean build (fix applied): `RESTORE` is rejected with
  `ERR Bad data format ... Duplicate set members detected`, so the key is
  never created (`EXISTS` -> 0, `SCARD` -> 0).
- Buggy build (`injection.patch` applied, duplicate check removed): `RESTORE`
  succeeds (`OK`), silently loading the corrupted payload — a set object
  containing a duplicate entry that also leaks memory during loading
  (`EXISTS` -> 1, `SCARD` -> 10, where the correct cardinality for the
  deduplicated set would be lower).

This is a deterministic, single-process reproduction: no timestamps, pids, or
server-log inspection are needed since the CLI's own reply already diverges
between builds.
