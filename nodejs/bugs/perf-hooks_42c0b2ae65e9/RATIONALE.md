# Re-introduced bug: PerformanceMark `detail` cloned via v8 serializer

**Bug.** `PerformanceMark`/`performance.measure` cloned `detail` with a home-grown
`structuredClone` built on `v8.DefaultSerializer`/`DefaultDeserializer` instead of the
spec-compliant structured clone, so some values (e.g. a RegExp) were not serialized correctly (nodejs/node#40840).

**Hunks.**
1. `lib/internal/util.js`: re-adds the `structuredClone()` helper (v8 serializer/deserializer round trip)
   and exports it. Corresponds to the fix's removal of that function and its export. (`hideStackFrames`
   wrapper omitted because it no longer exists in this file; plain arrow function instead.)
2. `lib/internal/perf/usertiming.js`: imports `structuredClone` from `internal/util` instead of
   `internal/worker/js_transferable` (the fix switched the import to the spec-compliant module; today's
   equivalent is js_transferable).

**Failing test.** `parallel/test-perf-hooks-usertiming` fails (stable over 2 runs) with
`Error: Unable to deserialize cloned data.` for `mark('a', { detail })` with the RegExp detail.
