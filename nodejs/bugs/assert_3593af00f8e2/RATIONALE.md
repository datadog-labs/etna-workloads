# Re-introduced bug: assert.fail() stack lacks the "Failed" message

**Bug.** When `assert.fail()` is called without a message, the default message `'Failed'` was only assigned to `err.message` after the AssertionError was constructed. The stack is captured at construction, so `err.stack` showed `undefined fail undefined` instead of `Failed`.

**Hunk (lib/assert.js, `Assert.prototype.fail`).** The release no longer has the old `fail(actual, expected, ...)` signature, so the fix's hunks are re-expressed for the current code.
- Fix hunk 1 replaced `internalMessage = 'Failed'` with `internalMessage = true; message = 'Failed'`. I reverted it to `internalMessage = 'Failed'` and left `message` undefined, so it is not passed to the constructor.
- Fix hunk 2 passed `message` always in `errArgs`. In the current code `message` is already in `errArgs`, and it is now undefined for the default case.
- Fix hunk 3 removed `err.message = internalMessage`. I restored `err.message = internalMessage;` after construction, so the message is set too late to appear in the stack.

**Failing test.** `parallel/test-assert-fail` fails on every run. The expected `stack: /Failed/` does not match the actual stack `AssertionError [ERR_ASSERTION]: undefined fail undefined`.
