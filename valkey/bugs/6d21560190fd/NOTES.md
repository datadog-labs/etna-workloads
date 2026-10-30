# Reproducer notes

`repro.sh` reproduces the bug fixed by commit 6d21560190fd ("Fix heap
overflow vulnerability in XAUTOCLAIM (CVE-2022-35951)").

It starts a single server, creates a stream `x` with one entry, creates a
consumer group `grp`, and reads the entry into the PEL via `XREADGROUP` so
there is a pending entry to claim. It then runs:

    XAUTOCLAIM x grp Bob 0 0-0 COUNT 8070450532247928833

This COUNT value is within `[1, LONG_MAX]` but large enough that, in the
pre-fix code, `count * sizeof(streamID)` (used to size the `deleted_ids`
allocation) and `count * attempts_factor` (used as the retry-attempts
counter) overflow.

- On the **clean** (fixed) build, `xautoclaimCommand` caps COUNT at
  `LONG_MAX / max(sizeof(streamID), attempts_factor)` before using it, so
  this COUNT is rejected with `ERR COUNT must be > 0`.
- On the **buggy** build (no such cap), the command is accepted and
  executes with the oversized/overflowed COUNT, returning a claim reply
  (`0-0`, the claimed entry, and no deleted ids) instead of an error. The
  server stays up for this particular stream state, but the underlying
  arithmetic overflow is the same integer overflow that, with a larger
  stream/PEL, leads to an undersized `deleted_ids` allocation and a heap
  buffer overflow.

The script prints the XAUTOCLAIM reply and a post-command `ping`, which is
enough to show the divergent behavior deterministically without relying on
timestamps, pids, or raw log output; it also checks the log for
`ASSERTION FAILED` in case a given build crashes instead.
