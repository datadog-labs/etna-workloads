# Re-introduced bug
assert: with a custom message, `assert.strictEqual`/`deepStrictEqual` (and the other operators in `kMethodsWithCustomMessageDiff`) no longer show the actual/expected diff; the error message is just the custom message.

## Change
`lib/internal/assert/assertion_error.js`, AssertionError constructor: the `if (kMethodsWithCustomMessageDiff.has(operator)) super(createErrDiff(..., message, diff)) else super(String(message))` branch (today's form of the fix's `operator === 'deepStrictEqual' || 'strictEqual'` hunk) is replaced by `super(String(message))`. The createErrDiff/getErrorMessage hunks are left alone: with no caller passing a message they are inert, equivalent to the pre-fix behaviour.

## Failing
`parallel/test-assert` fails ("Test assertion messages", "Functions as error message", ...), e.g. expected message 'oh no\n\n1 !== 2\n' but got 'oh no'.
