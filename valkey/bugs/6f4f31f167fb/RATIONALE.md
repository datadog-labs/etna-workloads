# Rationale

## Change: `tree/src/t_string.c`, `decrbyCommand`

The fix added an `incr == LLONG_MIN` check before `incrDecrCommand(c, -incr)`. It replies "decrement would overflow" because negating LLONG_MIN overflows. The 9.0.7 function still had the check in the same form, so I removed those lines. This restores the pre-fix code, which calls `incrDecrCommand(c, -incr)` unconditionally. Nothing else in `incrDecrCommand` covers the case. With a stored value of 0, the existing overflow check passes, because it only fires when the old value is nonzero. The command then succeeds and stores LLONG_MIN.

## Oracle result

`tests/unit/type/incr.tcl`: 1 of 32 cases fails, `DECRBY negation overflow`. `DECRBY x -9223372036854775808` returns `-9223372036854775808` instead of an `ERR` reply.
