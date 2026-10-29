# Rationale

## src/window.c, windowCodeRangeTest() (BIGNULL, reg1 IS NULL block)

Reverses the single implementation hunk of the fix. The fix replaced
`default: assert( op==OP_Le ); OP_IsNull...` with an explicit `case OP_Le:`
plus `default: assert( op==OP_Lt ); /* no-op */`. The pre-fix code had no
case for OP_Lt, so with `ORDER BY ... DESC NULLS FIRST` and a `PRECEDING`
frame boundary (DESC turns OP_Gt into OP_Lt), OP_Lt fell into the default
branch and was coded like OP_Le (jump if reg2 IS NULL). That is wrong; Lt must
be a no-op there. The restored code is the same as the pre-fix form
(only the `VdbeCoverage` line placement differs, which is cosmetic).

## Oracle failures

`windowA-4.0` (RANGE BETWEEN 2.50 PRECEDING AND 0.5 PRECEDING, ORDER BY d DESC
NULLS FIRST) hits `Assertion op==OP_Le failed` in windowCodeRangeTest (in
non-assert builds it would produce wrong window results for NULL rows).
Other windowA cases still pass.
