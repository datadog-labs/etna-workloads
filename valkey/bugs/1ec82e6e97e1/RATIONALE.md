# Rationale

This reintroduces the pre-fix integer-overflow bug addressed by the fix commit (SETRANGE/SORT, historical CVE fixed 2023-01-16) by reversing the fix's hunks in `tree/src`.

## src/t_string.c

- `checkStringLength(client *c, long long size)` restored to its original single-argument form:
  `if (!mustObeyClient(c) && size > server.proto_max_bulk_len) { ... }`
  This removes the `append` parameter, the `(uint64_t)size + append` sum, and the three-way overflow check
  (`total > proto_max_bulk_len || total < size || total < append`). This reverses the fix's hunk that changed
  `checkStringLength`'s signature and overflow handling.
- Both call sites in `setrangeCommand` reverted from `checkStringLength(c, offset, sdslen(value))` back to
  `checkStringLength(c, offset + sdslen(value))`, so the addition can overflow (wrap/UB) before the length
  check runs, as in the pre-fix code. Reverses the two `setrangeCommand` hunks.
- `appendCommand` reverted from `checkStringLength(c, stringObjectLen(o), sdslen(append->ptr))` back to
  computing `totlen = stringObjectLen(o) + sdslen(append->ptr)` and calling `checkStringLength(c, totlen)`,
  restoring the pre-fix unchecked addition. Reverses the `appendCommand` hunk.

These are the exact lines the fix touched; equivalence is that the fix's only purpose was to move the addition
inside an overflow-safe `uint64_t` computation and to add the overflow comparisons — removing that and restoring
the plain `long long` addition recreates the original overflow-prone computation.

## src/sort.c

- LIMIT sanity-checking in `sortCommandGeneric` reverted from:
  `start = min(max(limit_start, 0), vectorlen); limit_count = min(max(limit_count, -1), vectorlen);`
  back to the original:
  `start = (limit_start < 0) ? 0 : limit_start;`
  (with `limit_count` left unclamped). This removes the clamping of `start`/`limit_count` to `vectorlen`,
  so `end = start + limit_count - 1` can overflow for huge user-supplied LIMIT values, reproducing the
  pre-fix SORT/SORT_RO integer-overflow bug. Reverses the fix's hunk on this block.

## Oracle results

Running `./check.sh` shows the bug is reintroduced and crashes the test run:

- `tests/unit/type/string.tcl`: the `SETRANGE with huge offset` oracle case is among the failures, and the run
  aborts (incomplete run: crash, assert or timeout) consistent with the OOM-panic/abort the original bug caused
  with a huge SETRANGE offset. (Other unrelated cases, e.g. the `DELIFEQ`/`APPEND` tests, fail only because the
  server process dies mid-file and the remaining tests in that file never get a connection — expected fallout
  of the crash, not separate bugs.)
- `tests/unit/sort.tcl`: the run also reports an incomplete run (crash/assert/timeout); the `SETRANGE with huge
  offset` SORT_RO test and several subsequent cluster-mode tests fail as a result of the same kind of crash
  triggered via `SORT ... LIMIT` with a huge value, matching what the fix's added SORT test guards against.
