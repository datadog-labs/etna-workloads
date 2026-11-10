# Re-introduced bug: custom inspect leaks internal options / no indentation

Bug: when an object has a custom `[util.inspect.custom]` function, the options object passed to it exposes internal inspect state (`seen`, `budget`, `indentationLvl`), and strings returned by the custom function are no longer indented to the current depth (multi-line output is not re-indented).

Hunks (both in lib/internal/util/inspect.js):
1. `getUserOptions()` now also copies `budget`, `seen` and `indentationLvl` from ctx into the options object. Corresponds to the fix's hunk that stripped `budget, seen, indentationLvl` from the ctx passed to the user function (today's code builds a whitelist instead of spreading ctx, so the leak is re-expressed as adding those fields).
2. In `formatValue`, a string returned by the custom function is returned as-is again, removing the `\n` -> `\n` + indentation replacement. Corresponds to the fix's `ret.replace(/\n/g, ...)` hunk.

Failing test: parallel/test-util-inspect (not ok), because the custom inspect options check (`opts.seen`, `opts.budget`, `opts.indentationLvl` should be undefined) fails.
