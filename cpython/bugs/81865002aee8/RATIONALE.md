# Rationale

## Python/getargs.c `_parser_init`
Reverses the fix hunk that wrapped `new_kwtuple()` in a temporary main-interpreter
thread state (`PyThreadState_New(_PyInterpreterState_Main())` / Swap / Clear / Delete).
Removing it restores the pre-fix code: `kwtuple = new_kwtuple(keywords, len, pos);`
allocates the lazily-built tuple from whichever interpreter is active. When that is a
subinterpreter, the tuple stored in the static global `_PyArg_Parser.kwtuple` dangles
once that interpreter is destroyed. (The `pycore_pystate.h` include is left in place;
it is harmless.)

Not reverted: the `!` on the compare-exchange loop (separate "only the most recent parser
is linked" bug); the test-only/generated hunks and the clinic comment are not implementation.

## Oracle failure
`ParseTupleAndKeywords_Test.test_gh_119213` fails: the subinterpreter calls
`_testinternalcapi.gh_119213_getargs(spam='eggs')` first, the tuple is allocated in the
subinterpreter and freed on its destruction; the main interpreter's later cleanup hits the
freed object, producing a debug-allocator "pad bytes ... 0xdd OUCH" memory corruption error.
