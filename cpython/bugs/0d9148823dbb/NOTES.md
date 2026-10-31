Reproducer: enables sys.monitoring LINE events, then runs a generator that
`yield from`s another generator (from test_generator_with_line).

Clean: prints "done", exit 0. Buggy: the YIELD_VALUE assertion in the eval loop
fails (the instruction is INSTRUMENTED_LINE) and the process aborts (-6).
