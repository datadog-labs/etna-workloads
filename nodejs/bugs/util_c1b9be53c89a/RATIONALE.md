# Rationale

Bug: `util.format` formatted arguments differently depending on position/type of the first argument.
Trailing arguments after a format string (or after a plain string first argument) were stringified
with `${x}` unless they were objects/symbols, so a function printed its source (`1 () => {}`
rather than `1 [Function (anonymous)]`) instead of being inspected.

Hunk (lib/internal/util/inspect.js, trailing-args loop of `formatWithOptionsInternal`): corresponds to the
fix's replacement of the old trailing `while (a < arguments.length)` loop (with its
`typeof x !== 'object' && typeof x !== 'symbol'` → `${x}` branch) by the shared `formatValue`.
I restored the old per-position logic: non-object/non-symbol trailing values after a string first
argument use `${value}`; objects/symbols are inspected. Strings keep today's raw behaviour; a non-string first argument inspects everything.

Failing test: parallel/test-util-format (stable across two runs):
`actual: '1 () => {}', expected: '1 [Function (anonymous)]'`.
