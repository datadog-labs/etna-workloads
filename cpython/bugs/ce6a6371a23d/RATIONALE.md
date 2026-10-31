# GH-134879: INSTRUMENTED_FOR_ITER not advancing the list/tuple index

Fix hunks: removal of `null_or_index = PyStackRef_TagInt(-1)` on exhaustion, and
adding `null_or_index = PyStackRef_IncrementTaggedIntNoOverflow(null_or_index)`
before `INSTRUMENTED_JUMP` (plus the `stack_pointer[-1] = null_or_index` write-back).

In v3.15.2 the index is advanced inside `_PyForIter_VirtualIteratorNext` through
an `index_ptr`, so the old code can't be reversed literally. The equivalent
pre-fix behaviour: `INSTRUMENTED_FOR_ITER` (Python/bytecodes.c and the matching
case in Python/generated_cases.c.h) passes a throwaway copy (`next_index`) to the
helper, so the advanced index is never stored back to the stack. The specialised
list/tuple iteration under instrumentation (BRANCH events) then yields the same
item forever, as before the fix.

Oracle: test_monitoring cases that run `for` loops over lists/tuples with
monitoring enabled (e.g. test_134879, TestBranchAndJumpEvents.test_loop) fail or
hang (infinite loop / wrong results).
