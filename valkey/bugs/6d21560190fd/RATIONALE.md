# Rationale

Bug: CVE-2022-35951 heap overflow in `XAUTOCLAIM` via integer overflow on the
`COUNT` argument, fixed by commit 6d21560190fd (2022-09-22) in
`src/t_stream.c`. The logic and layout of `xautoclaimCommand()` in
`tree/src/t_stream.c` are essentially unchanged from the pre-fix 7.0-era
code (same `attempts_factor`/`count` variables, same allocation site), so
the fix hunks apply cleanly in spirit; only line numbers moved.

## Changes (each reverses one fix hunk)

1. **Removed the overflow-safe upper bound on COUNT.**
   The fix added:
   ```c
   long max_count = LONG_MAX / (max(sizeof(streamID), attempts_factor));
   if (getRangeLongFromObjectOrReply(c,c->argv[j+1],1,max_count,&count,"COUNT must be > 0") != C_OK)
   ```
   Reverted to the pre-fix bound of `LONG_MAX`:
   ```c
   if (getRangeLongFromObjectOrReply(c, c->argv[j + 1], 1, LONG_MAX, &count, "COUNT must be > 0") != C_OK)
   ```
   This is the root cause: `count` can again be set arbitrarily close to
   `LONG_MAX`, so the two multiplications below (`count * attempts_factor`
   and `count * sizeof(streamID)`) can overflow.

2. **Restored the unchecked `zmalloc` allocation (removed the
   `ztrymalloc`/failure-reply guard added by the fix).**
   The fix moved the allocation after the overflow-safe bound was enforced,
   switched it to `ztrymalloc`, and added a NULL check:
   ```c
   streamID *deleted_ids = ztrymalloc(count * sizeof(streamID));
   if (!deleted_ids) {
       addReplyError(c, "Insufficient memory, failed allocating transient memory, COUNT too high.");
       return;
   }
   ```
   This was removed entirely, and the original unchecked allocation
   ```c
   streamID *deleted_ids = zmalloc(count * sizeof(streamID));
   ```
   was put back in its original place, immediately before the claiming
   `while` loop (right after `now` is computed), matching the pre-fix
   source layout. With `count` unconstrained and the allocation
   unprotected, a crafted large `COUNT` makes `count * sizeof(streamID)`
   overflow to a small value, `zmalloc` succeeds with an undersized
   buffer, and the subsequent loop (bounded by `attempts = count *
   attempts_factor`, itself also overflowable) writes past the end of
   `deleted_ids` — the heap overflow the CVE describes.

   `attempts_factor` itself (and its use in `attempts = count *
   attempts_factor`) was left in place: it's a harmless local constant
   equal to the old literal `10`, and keeping it avoids an unrelated,
   unnecessary textual diff while the removed bound/alloc changes above
   are what actually restore the vulnerable behavior.

No other files or paths cover this case; `XAUTOCLAIM`'s COUNT parsing and
allocation exist only at this one call site in `src/t_stream.c`.

## Oracle result

`./check.sh` on `tests/unit/type/stream-cgroups.tcl` reports exactly one
oracle failure:

```
[err]: XAUTOCLAIM with out of range count
Expected an error matching 'ERR COUNT*' but got '0-0 {{3-0 {f v}}} {}'
```

i.e. `XAUTOCLAIM x grp Bob 0 3-0 COUNT 8070450532247928833` (the oracle's
overflow-triggering COUNT) is no longer rejected and is instead executed —
reproducing the pre-fix vulnerable behavior that the added test guards
against.
