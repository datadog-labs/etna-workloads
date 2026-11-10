# Rationale

**Bug.** Before the fix, the test runner child processes emitted TAP on stdout and the parent parsed it with a TAP lexer/parser, which was lossy and misparsed output. The fix switched children to a v8-serialized binary protocol (`NODE_TEST_CONTEXT=child-v8`, `v8-serializer` reporter, length-prefixed messages parsed in `FileTest`).

**Change (one hunk, lib/internal/test_runner/runner.js, `runTestFile`/`run` env).** Corresponds to the fix hunk `NODE_TEST_CONTEXT: 'child'` -> `'child-v8'`; reverted to `'child'`. Children then use the TAP reporter (utils.js still has that branch), but the parent no longer has a TAP parser, so the TAP text is treated as non-serialized data and surfaced only as raw `test:diagnostic` lines; real test results/errors are not delivered as structured events.

**Failing test.** `parallel/test-runner-reporters` fails (`not ok 1`), stable over repeated runs.
