# Re-introduced bug: util.formatWithOptions does not validate inspectOptions

**Bug.** `util.formatWithOptions(inspectOptions, ...args)` accepted any value as `inspectOptions` (undefined, null, false, numbers, strings, symbols, ...) instead of throwing `ERR_INVALID_ARG_TYPE`, which could cause confusion (nodejs/node#29726).

**Hunk (lib/internal/util/inspect.js).** The fix added a type check to the public `formatWithOptions` and split out an unvalidated `formatWithOptionsInternal` used by `format`. In today's code that split already exists, and the check is `validateObject(inspectOptions, 'inspectOptions', kValidateObjectAllowArray)`. I removed that single line from `formatWithOptions`, so it calls `formatWithOptionsInternal` directly, as the pre-fix code did.

**Failing test.** `parallel/test-util-format` fails: `AssertionError [ERR_ASSERTION]: Missing expected exception` at test-util-format.js:611, in the invalid-options loop (expected `ERR_INVALID_ARG_TYPE`, `/"inspectOptions".+object/`). It failed on both runs.
