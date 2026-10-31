repro.py runs `_testinternalcapi.gh_119213_getargs(spam='eggs')` in an isolated subinterpreter
(own obmalloc) via `test.support.run_in_subinterp_with_config`, the same as test_gh_119213.
The clean build prints `0`. The buggy build prints `0`, then crashes with SIGSEGV (exit -11) and
debug-allocator corruption messages. The Argument Clinic parser's lazily created kwtuple belongs
to the subinterpreter, which is destroyed while the parser still points to the tuple.
