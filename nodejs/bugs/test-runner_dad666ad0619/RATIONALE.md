# Rationale

Bug: `setup` (the user's `run({setup})` option, and the internal reporter setup) received the root `Test` object instead of the root `TestsStream` (`root.reporter`). The documented/expected argument is a stream.

Change: lib/internal/test_runner/runner.js, `await setup(root.reporter)` -> `await setup(root)`. This corresponds to the fix's runner.js hunk `setup?.(root.reporter)` -> `setup?.(root)` (reverted). Today's code has no `setup?.(root)` one-liner, and the internal reporter setup already takes a rootReporter, so with this change `compose(rootReporter, reporter)` also receives the Test object. The color-related hunks of the fix are not reproduced: the code was refactored and they are not required for this defect.

Failing tests: parallel/test-runner-run ("should pass instance of stream to setup": root.constructor.name is not 'TestsStream', strictEqual assertion fails) and parallel/test-runner-reporters (AssertionError, reporters get no valid stream). Failure was stable across runs.
