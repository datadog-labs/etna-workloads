# Rationale

## Change: tree/src/where.c, sqlite3WhereEnd()

The fix added `sqlite3VdbeJumpHere(v, pIn->addrInTop+1)` right after the
`OP_IfNoHope` is emitted (with a comment). It retargets the IN-LHS `OP_IsNull`
so it jumps past `OP_IfNoHope`, because `OP_IsNull` also skips the
`OP_Affinity` that `OP_IfNoHope` needs. The same code still exists in
version-3.54.1, so I removed that call and its comment. This restores the
pre-fix state: the `OP_IsNull` lands on the `OP_IfNoHope`, which can then
run with unset affinity and take a false-positive jump.

The fix's other hunk is an assert, which doesn't change behaviour. It is
still present and I left it alone.

## Oracle results

`in6-3.120` fails. The query returns an empty result instead of `'0' '10' |`:
the early-out fires wrongly and the output is incomplete.
The other nine cases pass, including `in6-3.130`.
