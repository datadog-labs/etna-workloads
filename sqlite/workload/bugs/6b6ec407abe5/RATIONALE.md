# Rationale

Changed: `tree/src/window.c`, `windowCodeRangeTest()`.

The fix added a pre-check just before the `reg1 = reg1 +/- regVal` arithmetic:
`if( op==OP_Ge && arith==OP_Add || op==OP_Le && arith==OP_Subtract ) goto lbl if reg2 >= reg1`
(compare the unmodified peer value first). This ensures that when floating-point
rounding makes `reg1 + regVal` smaller than `reg1` (large integers + 0.3), a row is
not treated as outside the frame, which would make xInverse() run before xStep().
In 3.54.1 the code was restructured (addrDone label, etc.), but the same
pre-check is still present. I removed that conditional OP_Ge/OP_Le block (the
only hunk reversed); the pre-fix code just does the arithmetic and then compares.

## Failing oracle cases
`window1-66.2.1` (test 66, large integers with `0.3 PRECEDING`): testfixture aborts with
`sumInverse: Assertion 'p->cnt>0' failed` - xInverse invoked before the matching xStep.
