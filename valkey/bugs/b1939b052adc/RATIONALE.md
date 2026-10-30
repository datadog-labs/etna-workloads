# CVE-2023-25155: Integer Overflow in RAND commands (fix.patch)

The fix changed each of `hrandfieldCommand`, `srandmemberWithCountCommand`,
and `zrandmemberCommand` to parse the `<count>` argument with
`getRangeLongFromObjectOrReply(c, argv, -LONG_MAX, LONG_MAX, &l, NULL)`
instead of plain `getLongFromObjectOrReply`, rejecting `LONG_MIN` (whose
negation overflows a `long`). It also tightened the `withvalues`/`withscores`
bound check from `l < LONG_MIN/2` to `l < -LONG_MAX/2`, for the same reason
(the old bound still let `LONG_MIN` through in that branch).

The 9.0.7 code for these three commands is essentially unchanged in
structure from the pre-fix version (same functions, same call sites), so the
fix hunks were reverted directly rather than re-derived:

- `src/t_hash.c`, `hrandfieldCommand` (~line 2353): count parsing reverted to
  `getLongFromObjectOrReply(c, c->argv[2], &l, NULL)`; the `withvalues`
  bound reverted to `l < LONG_MIN / 2`.
- `src/t_set.c`, `srandmemberWithCountCommand` (~line 1011): count parsing
  reverted to `getLongFromObjectOrReply(c, c->argv[2], &l, NULL)`.
- `src/t_zset.c`, `zrandmemberCommand` (~line 4282): count parsing reverted
  to `getLongFromObjectOrReply(c, c->argv[2], &l, NULL)`; the `withscores`
  bound reverted to `l < LONG_MIN / 2`.

Each changed line is the exact textual inverse of the corresponding fix
hunk (same function, same statement, same expression), so no other code
needed touching: with the plain parser, passing `count = LONG_MIN`
(`-9223372036854775808`) is accepted instead of rejected, and the later
code that negates a negative count (`count = -(unsigned long)l` type logic
in `hrandfieldWithCountCommand`/`srandmemberWithCountCommand`/
`zrandmemberWithCountCommand`) overflows, as before the fix.

## Oracle results (`./check.sh`)

- `tests/unit/type/set.tcl`: 20/117 oracle cases fail, explicitly flagged
  "(incomplete run: crash, assert or timeout)". The run aborts right at
  `SRANDMEMBER count overflow`; the server stops responding
  (`couldn't open socket: connection refused`) and every subsequent test in
  the file fails as collateral damage — matching the fix's own
  regression test for this exact case.
- `tests/unit/type/zset.tcl`: 10/315 oracle cases fail, also flagged
  "(incomplete run: crash, assert or timeout)", aborting at
  `ZRANDMEMBER count overflow` with the same connection-refused cascade.
- `tests/unit/type/hash.tcl`: 69/75 oracle cases fail. `HRANDFIELD count
  overflow` is one of only a handful of tests near the top of the file
  (line 74, before almost all other hash tests), and the server again stops
  responding partway through the file, so essentially every test after it
  fails with connection-refused — the same crash pattern as set/zset, just
  without the file-level "(incomplete run…)" tag.

This reproduces the CVE-2023-25155 integer overflow: `COUNT -9223372036854775808`
to HRANDFIELD/SRANDMEMBER/ZRANDMEMBER is accepted instead of being rejected
with "value is out of range", and crashes/asserts the server instead,
exactly as the fix's added tests check for.
