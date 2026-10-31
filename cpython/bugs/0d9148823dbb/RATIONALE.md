# gh-118414 reintroduced

Fix: YIELD_VALUE's debug assertion on the caller's instruction rejected
INSTRUMENTED_LINE / INSTRUMENTED_INSTRUCTION (it only accepted SEND/FOR_ITER/etc. via _PyOpcode_Deopt, which does not map those two).

In v3.15.2 the assertion (Py_DEBUG only) in `_YIELD_VALUE` uses `_Py_GetBaseCodeUnit(...)`, which looks through
instrumentation, i.e. the fix's added INSTRUMENTED_LINE/INSTRUMENTED_INSTRUCTION allowance. I replaced it with the raw opcode
`_PyFrame_GetBytecode(frame)[i].op.code` checked via `_PyOpcode_Deopt[opcode] == SEND || FOR_ITER`, the pre-fix form
(no LINE/INSTRUCTION case). Changed in Python/bytecodes.c and the generated copies
(Python/generated_cases.c.h x2 for YIELD_VALUE and INSTRUMENTED_YIELD_VALUE, Python/executor_cases.c.h).

Oracle: test_monitoring (LineMonitoringTest.test_generator_with_line etc.) aborts with the assertion
`_PyOpcode_Deopt[opcode] == SEND || ... FOR_ITER` failing; the run crashes, so the whole file's cases are reported failing.
