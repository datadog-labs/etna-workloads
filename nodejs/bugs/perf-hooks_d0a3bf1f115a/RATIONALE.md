# Rationale

**Bug:** `performance.measure(name, startMark, endMark)` required `endMark`. Omitting it
(`measure('x')` or `measure('x', 'A')`) threw because `undefined` was stringified to
"undefined" and looked up as a mark, instead of measuring up to "now" (User Timing spec).

**Change (lib/internal/perf/usertiming.js, `calculateStartDuration`):** added a branch
`else if (!optionsValid) { end = getMark(`${endMark}`); }` before the `end = now()` fallback.
This corresponds to the fix's lib/perf_hooks.js hunk (which made endMark validation/stringification
conditional on being supplied, with the missing case defaulting to now) and its src/node_perf.cc hunk
(`PERFORMANCE_NOW()` when args[2] is undefined). In today's code that logic lives in JS, so
one hunk restores the old "endMark is always looked up" behaviour. The options-object path is unchanged.

**Failing test:** parallel/test-performance-measure fails (stable across runs):
`DOMException [SyntaxError]: The "undefined" performance mark has not been set`.
