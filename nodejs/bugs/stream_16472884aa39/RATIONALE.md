# Rationale

**Bug:** If a TransformStream's readable side is cancelled while a write is pending/late, the controller's algorithms are cleared (`transformAlgorithm = undefined`). A subsequent `performTransform` then calls `undefined(...)`, leaking an internal `TypeError: transformAlgorithm is not a function` to the writer.

**Change (lib/internal/webstreams/transformstream.js):** In `transformStreamDefaultControllerPerformTransform`, removed the `if (transformAlgorithm === undefined) return kResolvedPromise;` guard. This corresponds to the fix's added `transformAlgorithm === undefined` early-return hunk (re-expressed for today's non-async implementation, where the guard returns `kResolvedPromise`). Without it, the call throws a TypeError, which is converted to a rejection and errors the stream.

**Failing test:** parallel/test-whatwg-transformstream-cancel-write-race — `AssertionError: Internal implementation error leaked: transformAlgorithm is not a function` (stable over 2 runs).
