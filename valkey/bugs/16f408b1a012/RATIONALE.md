# Rationale

## Bug

CVE-2023-22458: `HRANDFIELD`/`ZRANDMEMBER` with a negative `<count>` and the
`WITHVALUES`/`WITHSCORES` option multiply `count` by 2 internally (to
reserve one array slot per field+value / member+score). For a very large
negative count (close to `LONG_MIN`) this multiplication overflows a
`long`, producing an undersized or corrupted allocation and crashing the
server. The fix added a range check rejecting counts outside
`[LONG_MIN/2, LONG_MAX/2]` before entering the WITHVALUES/WITHSCORES path.

## Changes (tree/src)

- `src/t_hash.c`, `hrandfieldCommand`: removed the
  ```c
  if (l < -LONG_MAX / 2 || l > LONG_MAX / 2) {
      addReplyError(c, "value is out of range");
      return;
  }
  ```
  block that runs when `withvalues` is set. This directly reverses the
  `t_hash.c` hunk of `fix.patch`, which introduced exactly this check
  (the 9.0.7 code already used `-LONG_MAX`/`LONG_MAX` as the parse bounds,
  same as the fix's `LONG_MIN`/`LONG_MAX`, so the check text is equivalent
  modulo that pre-existing difference).

- `src/t_zset.c`, `zrandmemberCommand`: removed the equivalent block in the
  `withscores` branch. Reverses the `t_zset.c` hunk of `fix.patch`.

Both removals are the smallest change that restores the pre-fix behaviour:
the overflow check is gone, but the surrounding `argc`/syntax validation is
untouched, so a large negative count with `WITHVALUES`/`WITHSCORES` now
flows straight into `hrandfieldWithCountCommand`/`zrandmemberWithCountCommand`
with the unchecked count, and the internal `count * 2` overflow is
reinstated.

## Oracle result (`./check.sh`)

- `tests/unit/type/hash.tcl`: "HRANDFIELD count overflow" fails, and the
  server stops responding ("couldn't open socket: connection refused") for
  all subsequent tests in the file — i.e. the command crashes the server,
  matching the panic the CVE describes.
- `tests/unit/type/zset.tcl`: "ZRANDMEMBER count overflow" fails the same
  way (connection refused after the command), among the 10 cases that fail
  in that run.

Both of the oracle cases the fix's tests added for this bug fail, with the
same crash signature (socket refused / incomplete run) that the original
vulnerability produced.
