Reproducer: compiles the gh-120367 AST (try/except/else with match/finally, all locations stripped) so the CFG has redundant NOPs/jumps after cold blocks are moved to the end.
Clean: prints "ok". Buggy: the compiler's assertion (redundant jumps/nops remaining) fails and the interpreter aborts.
