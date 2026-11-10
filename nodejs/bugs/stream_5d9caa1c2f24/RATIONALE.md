# Rationale
Bug: stream iteration helpers `map`, `filter`, `flatMap` were async generator functions, so argument validation (invalid fn/options) ran lazily on first iteration and surfaced as a rejected promise instead of a synchronous throw.

Changes (all in lib/internal/streams/operators.js), each reversing a fix hunk re-expressed for today's code:
- `map`: `function map` -> `async function* map`, and the `return async function*(){...}.call(this)` wrapper removed (body inlined in a block), so validation is deferred until first `next()`. (fix hunk 1)
- `filter`: back to `async function* filter` using `yield* map.call(...)` instead of returning the stream. (fix hunk 2)
- `flatMap`: back to `async function* flatMap` iterating `map.call(...)` inside the generator. (fix hunk 3)

Failing tests (all three oracles, stable over two runs): parallel/test-stream-filter, test-stream-flatMap, test-stream-map — `assert.throws(() => Readable.from([1]).map(1), ...)` fails because nothing is thrown synchronously (Missing expected exception).
