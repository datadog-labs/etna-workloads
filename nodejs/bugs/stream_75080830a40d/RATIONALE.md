# Re-introduced bug: TransformStream init reads Object.prototype.type

**Bug.** `new TransformStream()` builds its internal WritableStream/ReadableStream by passing plain
object literals (underlying sink/source) to the public constructors. Those constructors read
`sink.type` / `source.type`, so an inherited `Object.prototype.type` (getter/setter or value) is
observed (or even breaks construction) during TransformStream init.

**Change** (`lib/internal/webstreams/transformstream.js`, `initializeTransformStream`).
The fix added `__proto__: null` to the two object literals passed to `new WritableStream({...})` and
`new ReadableStream({...})`. In the current release those literals no longer exist: the code uses the
internal `createWritableStream`/`createReadableStream` helpers (which use the `kSkipThrow` path and never read `type`).
I replaced those two calls (the two hunks) by `new WritableStream({start, write, close, abort}, {highWaterMark, size})`
and `new ReadableStream({start, pull, cancel}, {...})` using plain object literals without `__proto__: null`,
and swapped the imports accordingly. This restores the pre-fix behavior where the literal inherits from Object.prototype and the constructor reads `.type`.

**Failing test.** `parallel/test-whatwg-transformstream` fails (stable over runs):
`AssertionError [ERR_ASSERTION]: get %Object.prototype%.type` thrown from `new WritableStream (writablestream:195)`
via `initializeTransformStream`.
