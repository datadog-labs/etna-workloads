# Re-introduced bug: Error.stackTraceLimit not fixed up during snapshot building

**Bug.** V8 does not install `Error.stackTraceLimit` in a snapshot-building context, so `error.stack` is `undefined` in the builder script unless the user sets the limit themselves. The fix installed it from `--stack-trace-limit`, deleted it again after user serialize callbacks, and only restored it after deserialization if the user had changed it (with warnings).

**Change (lib/internal/main/mksnapshot.js only).**
- The hunk that defines `initialStackTraceLimitDesc` and calls `ObjectDefineProperty(Error, 'stackTraceLimit', ...)` is removed. This corresponds to the fix's added install block. Without it the builder context has no limit, so `error.stack` is undefined.
- The `addAfterUserSerializeCallback` block with the modification check and warning is replaced by the old `addSerializeCallback` that captures the descriptor and deletes it. This corresponds to the fix's replacement of the old serialize callback.
- The deserialize callback is restored to its old form. It restores `stackTraceLimitDesc`, which is only defined if the property existed.
- The imports are reverted: `addSerializeCallback` is imported in place of `addAfterUserSerializeCallback`, and `getOptionValue` is no longer imported.
- `lib/internal/v8/startup_snapshot.js` is left alone. `addAfterUserSerializeCallback` stays there, unused.

**Failing tests (both).** `parallel/test-snapshot-stack-trace-limit-mutation` and `parallel/test-snapshot-stack-trace-limit` print `not ok`. The first fails because `Error.stackTraceLimit` is not a number in the builder and the "has been modified" warning is missing. The second fails because the expected "Error.stackTraceLimit = 50" output is missing and no stack frames are produced during building.
