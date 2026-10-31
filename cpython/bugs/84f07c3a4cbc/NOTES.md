repro.py calls `b'abc'.__buffer__(-2**31 - 1)` (flags below INT_MIN).

- clean: raises OverflowError "buffer flags out of range"; prints it, exit 0.
- buggy: the lower bound check is missing, so Py_SAFE_DOWNCAST's assert fails in wrap_buffer (typeobject.c:10463) and the process aborts (exit 134).

I ran both interpreters directly, because ./check.sh failed in the sandbox (bwrap couldn't find a `.claude/launch.json` path). It was not run to completion.
