# NOTES

`repro.sh` reproduces the bug fixed by commit 41d92f0bc686 ("Check and
reject invalid slot import job names during RDB load"), reintroduced by
`injection.patch`.

What it does:
1. Starts a plain `$VALKEY_SERVER` instance, issues `SAVE` to produce a
   normal, empty RDB, then shuts it down.
2. Crafts a malicious RDB by taking that empty RDB and appending a
   `RDB_OPCODE_SLOT_IMPORT` (0xF3) record whose `job_name` string is 1 byte
   long (`"A"`) instead of the required `CLUSTER_NAMELEN` (40) bytes,
   followed by one slot range `[0,0]`, the EOF opcode, and a zeroed
   (checksum-disabled) trailer.
3. Starts a cluster-enabled `$VALKEY_SERVER` instance pointed at that
   crafted RDB and observes whether it comes up (`PING` answers) or rejects
   the file during load (logs "Invalid slot import job name length in
   RDB" and exits/aborts loading without accepting connections).

`clusterRDBLoadSlotImport()` always passes `job_name` to
`createSlotImportJob()`, which unconditionally `memcpy`s `CLUSTER_NAMELEN`
bytes from it into a fixed-size buffer — a heap out-of-bounds read if the
string is shorter, as it is here. The fix rejects any slot-import record
whose `job_name` length isn't exactly `CLUSTER_NAMELEN` before that memcpy.

Difference between builds (`RESULT=` line in the script's output):
- **clean** (fix present): `RESULT=REJECTED` — the server detects the
  short `job_name`, logs the length-check error, and aborts loading the
  RDB; it never becomes ready to accept connections.
- **buggy** (`injection.patch` applied, fix removed): `RESULT=ACCEPTED` —
  the server happily loads the corrupt job (triggering the OOB `memcpy`
  inside `createSlotImportJob()`), creates a slot-import job from garbage
  data, and comes up answering `PING` and `CLUSTER INFO` as if nothing
  were wrong.

The server's own raw RDB-diagnostic dump (an automatic re-exec into
check-rdb-style output on load failure) is redirected to a file instead of
the script's stdout/stderr, since it includes the RDB's creation
timestamp and would otherwise make output nondeterministic; the pass/fail
verdict instead comes from `PING` connectivity and a fixed log-grep.
