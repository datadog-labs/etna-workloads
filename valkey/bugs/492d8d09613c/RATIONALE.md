# Rationale

All changes are in `tree/src/rdb.c`, in `rdbLoadObject()`'s stream-loading
code. They revert the three `raxInsert` -> `raxTryInsert` hunks of
`fix.patch` (the fourth hunk, adding a missing `streamFreeNACK(nack)` call
on the consumer-PEL error path, is left in place; see below).

1. Stream listpack node insert into `s->rax` (around rdb.c:2614):
   `raxTryInsert` reverted back to `raxInsert`. `raxInsert` overwrites an
   existing entry with the same key and returns 0 (failure) only via the
   "duplicate key" path, but it does not leave the tree untouched the way
   `raxTryInsert` does - when the key already exists, the old `raxInsert`
   API still replaces the node's associated data with the new pointer
   before reporting failure. The corrupt-RDB error handler then does
   `zfree(lp)` followed by `decrRefCount(o)`, which walks the rax and
   frees every listpack still referenced there - including the one whose
   pointer was just installed and already freed. That is the double free
   the fix removed.

2. Global PEL insert into `cgroup->pel` (around rdb.c:2761): same
   `raxTryInsert` -> `raxInsert` reversion, same mechanism - a duplicate
   PEL entry overwrites the existing NACK pointer in the rax, and the
   following `decrRefCount(o)` cleanup frees the stream's PELs, including
   the now-dangling/duplicated NACK, leading to a double free of the NACK
   structure.

3. Consumer PEL insert into `consumer->pel` (around rdb.c:2846): same
   `raxTryInsert` -> `raxInsert` reversion, for the local per-consumer PEL.
   This is the exact case the fix's added test exercises (a nodekey/rawid
   duplicated across stream records so that the second insert collides
   with the first).

I did not revert the `streamFreeNACK(nack)` addition on the consumer-PEL
error path (the fix's fourth hunk), since it is an independent, purely
corrective addition (freeing the NACK that `raxTryInsert` correctly
rejected) and not part of the `raxInsert`/`raxTryInsert` defect itself;
leaving it in does not suppress the reintroduced bug, since the crash
happens via the `s->rax` and PEL-overwrite double-free paths before/while
this code runs, not because of a missing free on the rejected-duplicate
path.

Every changed line is a straight revert of one of the three `raxInsert`
hunks in `fix.patch`; no other logic, conditionals, or files were touched.

## Oracle result

Running `./check.sh` builds and runs the oracle. Of the 89 oracle cases in
`tests/integration/corrupt-dump.tcl`, 88 pass and exactly one fails:

    corrupt payload: fuzzer findings - stream double free listpack when insert dup node to rax returns 0

The test sends a crafted RESTORE payload with a duplicate stream rax node
key, expecting the server to reject it cleanly with a `Bad data format`
error and remain alive (`r ping` succeeding afterward). With the bug
reintroduced, the server instead double-frees memory while handling the
corrupt payload and crashes/exits, so the test's `r restore ...` call
fails with `I/O error reading reply` instead of raising the expected
`Bad data format` error - i.e., the connection drops because the server
process died, which is the double-free crash the original bug caused.
