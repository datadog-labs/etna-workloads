# Rationale

**Bug:** A transferred stream (via structuredClone/postMessage with `transfer`) did not get the closest transferable superclass as its prototype. The internal constructor's instances had `InternalTransferred*Stream.prototype` as their prototype instead of e.g. `TransformStream.prototype`, so `Object.getPrototypeOf(transferred) !== TransformStream.prototype`.

**Change:** one hunk in `lib/internal/webstreams/transformstream.js`. It removes `ObjectSetPrototypeOf(this, TransformStream.prototype);` from `InternalTransferredTransformStream`. This corresponds to the fix's transformstream.js hunk.

The fix's readablestream.js and writablestream.js hunks have no counterpart in this release. Those files no longer have the `Internal*` constructors the fix touched, so no change was made there.

**Failing test:** `parallel/test-structuredClone-global` fails with "Expected "actual" to be reference-equal to "expected"", with actual `TransformStream {}`. It failed on both runs.
