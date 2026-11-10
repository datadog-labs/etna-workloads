# Re-introduced bug: ReadableStream.from({}) does not throw ERR_ARG_NOT_ITERABLE

**Bug.** `ReadableStream.from()` called with a non-iterable (e.g. `{}`) should throw a `TypeError` with code `ERR_ARG_NOT_ITERABLE`. Before the fix, the missing iterator method (`undefined`) was invoked anyway, so a generic `TypeError` with no code was thrown.

**Adaptation.** `getIterator` in `lib/internal/webstreams/util.js` no longer exists in this release. The logic now lives in `readableStreamFromIterable` in `lib/internal/webstreams/readablestream.js`.

**Hunks (one file, `lib/internal/webstreams/readablestream.js`).**
1. Removed the `iteratorGetter == null || typeof iteratorGetter !== 'function'` check that throws `ERR_ARG_NOT_ITERABLE`. This corresponds to both added `ERR_ARG_NOT_ITERABLE` checks in the fix (the `syncMethod === undefined` check and the `method === undefined` check). Today's code has a single combined check. Without it, `FunctionPrototypeCall(undefined, iterable)` throws a plain TypeError, which is the pre-fix behaviour.
2. Removed the now-unused `ERR_ARG_NOT_ITERABLE` import. This corresponds to the import hunk in the fix.

**Failing test.** `parallel/test-webstream-readable-from` reports `not ok`. The assertion in the test expects `code: 'ERR_ARG_NOT_ITERABLE'`, but the thrown TypeError has a different code. I ran it twice and it failed both times. I only checked the TAP `not ok` line and did not capture the exact assertion message.
