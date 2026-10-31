repro.py builds small instruction sequences with `_testinternalcapi` (the same path the upstream `OptimizeLoadFastTestCase` tests use). It runs `optimize_cfg` on them and prints the resulting opcodes. The sequences cover FORMAT_SIMPLE, PUSH_EXC_INFO, LOAD_SPECIAL and SET_FUNCTION_ATTRIBUTE, each applied to a value from LOAD_FAST.

Clean interpreter: LOAD_FAST stays LOAD_FAST, because these ops leave their operand on the stack.
Buggy interpreter: the injection removes the stack-effect handling for these ops in the load-fast borrow optimization. LOAD_FAST is wrongly rewritten to LOAD_FAST_BORROW in all four cases.

I couldn't run `./check.sh`, because the sandbox blocked its bwrap mount. I ran both interpreters directly with PYTHONHASHSEED=0 and compared the output. Both exit 0, and only stdout differs.
