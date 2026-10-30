# Reproducer notes

`repro.sh` starts a single `valkey-server`, then issues a `RESTORE` for key
`corrupt` with a crafted `RDB_TYPE_LIST_QUICKLIST_2` DUMP payload (the same
payload used by the upstream regression test added in commit 1808618f5d1f,
"corrupt payload: quicklist listpack entry start with EOF"). The payload's
single listpack node contains one entry whose declared start position is the
listpack's own trailing EOF (0xFF) byte, i.e. the listpack claims to have
content that actually begins at its terminator.

The payload has a valid RDB version/CRC64 footer and contains embedded NUL
bytes, so it can't be passed as a plain command-line argument (argv strings
are NUL-terminated); it's written to `payload.bin` with `printf` and sent via
`valkey-cli -x`, which reads the last argument from stdin as a binary-safe
blob.

After the `RESTORE`, the script runs `TYPE corrupt` and `LRANGE corrupt 0 -1`
and pings the server again, then greps the log for `ASSERTION FAILED`.

Observed difference:
- **Clean build**: `lpValidateIntegrity()` notices `p != lp + size - 1` after
  the scan loop and rejects the listpack, so `RESTORE` replies
  `ERR Bad data format`, the key is never created (`TYPE` → `none`, `LRANGE`
  → empty), and the server keeps responding to `PING`.
- **Buggy build** (missing that end-of-listpack check): `RESTORE` accepts the
  corrupt payload (`OK`) and creates the list. The subsequent `LRANGE`
  dereferences the bogus entry and the server hits an `ASSERTION FAILED` and
  aborts/crashes: the connection is dropped (`Could not connect ... Connection
  refused`) and `ASSERTION` is printed because the log contains
  `ASSERTION FAILED`.
