# Rationale

Fix: in SQLITE_FCNTL_PERSIST_WAL query mode (`*pArg<0`) the VFS computed the
flag into a local `bPersist` instead of storing it through `pArg`, so callers
saw the input value (-1). The fix writes `*(int*)pArg`.

In 3.54.1 this logic was refactored into `unixModeBit()`/`winModeBit()`, which
correctly write `*pArg`. Both are shared with POWERSAFE_OVERWRITE, so I left
them alone and restored the pre-fix code in the PERSIST_WAL cases only:

- src/os_unix.c `unixFileControl`, SQLITE_FCNTL_PERSIST_WAL: reverses the
  os_unix.c hunk; the query branch assigns a local `bPersist`, not `*pArg`.
  Set/clear still goes through `unixModeBit`.
- src/os_win.c `winFileControl`: same, reversing the os_win.c hunk.

Effect: querying returns -1 unchanged. wal.c (~line 2622) queries the flag
with -1 on close, sees -1 instead of 0/1, so the -wal/-shm files are not kept.

Oracle failures (test/walpersist.test): 1.5, 1.7, 1.9 (query returns
`0 -1` instead of `0 0`/`0 1`), 1.11 (wal/shm deleted on close), 2.2, 3.3
(test.db-wal missing).
