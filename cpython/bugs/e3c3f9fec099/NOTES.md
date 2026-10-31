Reproducer: a rich comparison (`x > 0`) returns an object whose `__bool__` raises, inside an `if` in a function.
The fused compare+to-bool path then fails; the buggy build jumps to `pop_2_error` and pops the stack twice
(the operands were already consumed), so the clean build prints `TypeError('no bool')` three times
while the buggy build aborts with `Assertion WITHIN_STACK_BOUNDS() failed` (exit -6).
