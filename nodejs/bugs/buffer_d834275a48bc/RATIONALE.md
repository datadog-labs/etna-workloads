# Bug
Buffer's custom inspect function, when the buffer has extra own non-index properties, formatted them by calling the internal `formatProperty()` with the `ctx` passed to the custom inspect function. That `ctx` is a public-API copy without the internals (e.g. `ctx.seen`), so inspecting a Buffer with extra properties (`b.prop = ...`) throws instead of printing `<Buffer 31 32, inspect: undefined, prop: Uint8Array []>`.

# Hunks
- lib/buffer.js import: replaces `inspect: utilInspect` with `formatProperty, kObjectType` (fix hunk 1, reversed). Also swaps now-unused `ArrayPrototypeForEach`/`StringPrototypeSlice` primordials for `ArrayPrototypeReduce`.
- lib/buffer.js inspect body: replaces the null-prototype-object + `utilInspect(...).slice(27,-2)` logic with the old reduce calling `formatProperty(ctx, this, recurseTimes, key, kObjectType)` (fix hunk 2, reversed).
- lib/internal/util/inspect.js exports: re-add `formatProperty` and `kObjectType` (fix hunk 3, reversed).

# Failing test
parallel/test-buffer-inspect: `TypeError: Cannot read properties of undefined (reading 'includes')` at formatValue (`ctx.seen.includes`), via formatProperty from Buffer.inspect, at the `b.prop = new Uint8Array(0)` inspect check. Stable across 2 runs.
