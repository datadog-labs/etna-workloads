# Re-introduced bug: atob/btoa with no arguments

**Bug.** `buffer.atob()` / `buffer.btoa()` called with no arguments did not throw a
`TypeError` (`ERR_MISSING_ARGS`). The input was coerced to the string `"undefined"` and processed
(`atob()` threw an `InvalidCharacterError` DOMException, `btoa()` returned `"dW5kZWZpbmVk"`).

**Hunks (lib/buffer.js only).**
1. `btoa`: removes the `if (arguments.length === 0) throw new ERR_MISSING_ARGS('input')` guard.
   This corresponds to the fix's btoa hunk. Without it, `undefined` is stringified as before the fix.
2. `atob`: removes the same guard, corresponding to the fix's atob hunk.
The fix's import hunk (adding `ERR_MISSING_ARGS` to the destructuring) is not reversed. The release
already imports it for another use at line 976, so removing it would break that code.
The test hunks are not touched.

**Failing test.** `parallel/test-btoa-atob` fails, and it fails on every run. Message:
`AssertionError [ERR_ASSERTION]: The input did not match the regular expression /TypeError/. Input:
'InvalidCharacterError: The string to be decoded is not correctly encoded.'`
