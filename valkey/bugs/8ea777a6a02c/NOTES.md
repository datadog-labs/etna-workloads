# NOTES

`repro.sh` starts one `valkey-server`, enables
`debug set-skip-checksum-validation 1` (the crafted payloads below don't
carry a valid CRC64), and issues two `RESTORE` commands whose serialized
value declares a length that decodes to 0:

- `RESTORE hashkey 0 "\x04\xC0\x21\x09\x00..."` — type `RDB_TYPE_HASH`
- `RESTORE zsetkey 0 "\x05\xC0\x01\x09\x00..."` — type `RDB_TYPE_ZSET_2`

Both payloads are the exact bytes from the upstream regression tests
`corrupt payload: fuzzer findings - hash with len of 0` and
`corrupt payload: fuzzer findings - empty zset`
(`tests/integration/corrupt-dump.tcl`), which were added by the fix
commit. Since the payloads contain embedded NUL bytes, they can't be
passed as a `valkey-cli` command-line argument (argv is NUL-terminated),
so the script sends them as raw RESP over a `/dev/tcp` socket instead.

`rdbLoadObject()` in `rdb.c` reads the length of these aggregate types
and, on the fixed build, immediately rejects a length of 0 ("goto
emptykey"), which the caller (`restoreCommand`) turns into a
`-ERR Bad data format` reply, leaving the key absent. With
`injection.patch` applied (reverting that `if (len == 0) goto emptykey;`
check for `RDB_TYPE_HASH`/`RDB_TYPE_ZSET_2`/etc.), the same bytes decode
as a valid, empty hash/zset and `RESTORE` replies `+OK`, silently
creating an empty key.

## Observed diff (`./check.sh`)

- Clean build: both `RESTORE`s reply `-ERR Bad data format`,
  `EXISTS hashkey`/`EXISTS zsetkey` are `0`, `DBSIZE` is `0`.
- Buggy build: both `RESTORE`s reply `+OK`, `EXISTS hashkey`/
  `EXISTS zsetkey` are `1`, `DBSIZE` is `2`.

Both builds otherwise stay up and respond `PONG` to `PING`, and exit
status is `0` in both cases — the divergence is purely in the command
replies and resulting keyspace state.
