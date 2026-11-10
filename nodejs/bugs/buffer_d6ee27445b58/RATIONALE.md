# Blob options validation bug

**Bug:** The `Blob` constructor validated `options` with `validateObject`, which rejects `null` and, depending on the check, non-plain objects. The Web IDL "dictionary" conversion accepts `undefined`, `null`, objects and functions. So `new Blob([], null)` throws `ERR_INVALID_ARG_TYPE`. Functions and arrays are also not handled per the dictionary rules.

**Changes (all in `lib/internal/blob.js`; the release no longer has the fix's `validators.js` hunk in a reversible form, and the helper is left exported but unused):**
- Import hunk: import `validateObject` instead of `validateDictionary`. This corresponds to the fix's import change.
- Constructor signature: `options = kEmptyObject` instead of `options`. This reverts the fix's signature hunk.
- Validation call: `validateObject(options, 'options')` instead of `validateDictionary(...)`. This reverts the fix's validation hunk.
- Destructuring: `} = options;` instead of `options ?? kEmptyObject`. This reverts the fix's destructuring hunk.

**Failing test:** `parallel/test-blob` fails. The new test block calls `new Blob([], null)`, which now throws `ERR_INVALID_ARG_TYPE`.
