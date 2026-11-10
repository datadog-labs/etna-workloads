# Re-introduced bug: test_runner `expectFailure` passing test not reported as failure

Bug: a test marked `expectFailure` that actually passes was reported as a pass instead of
a failure ("test was expected to fail but passed").

Change (lib/internal/test_runner/test.js, `Test.pass()`): removed the early block
`if (this.error == null && this.expectFailure && !this.skipped) { ...ERR_TEST_FAILURE(..., kExpectedFailure) }`.
This corresponds to the fix's single implementation hunk (adding that block to `pass()`),
re-expressed for today's code (the condition is `this.expectFailure` rather than `=== true`
because expectFailure is now parsed into an object/value). Without it, passing tests with
expectFailure fall through to the normal pass path.

Failing test: parallel/test-runner-expect-error-but-pass (`test:pass` mustNotCall violated /
`test:fail` never called). parallel/test-runner-expect-error still passes. Verified twice.
