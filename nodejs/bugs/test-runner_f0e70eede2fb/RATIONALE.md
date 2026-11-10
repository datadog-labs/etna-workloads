# Re-introduced bug: test runner deserializer mishandles messages split across chunks

**Bug.** When a serialized test-runner message was split across two stdout chunks inside its size-prefix/V8 header (first `kSerializedSizeHeader` bytes), the parent process treated the second chunk as unrelated non-serialized output. It reported both fragments as `test:stdout` and lost the real event.

**Change (lib/internal/test_runner/runner.js, `FileTest.parseMessage`).** The fix added a hunk to `parseMessage` that, when `#rawBuffer[0]` is shorter than `kSerializedSizeHeader`, concatenates the new data onto it instead of pushing a new buffer. I removed that branch, so the data is always pushed as a separate buffer, as before the fix. The rest of the fix's hunks (serializer header layout, `drain()`, header-offset changes) are already in the release in a rewritten form. I did not touch them, so this is a single-hunk re-introduction.

**Failing tests** (`parallel/test-runner-v8-deserializer`, fails on repeated runs). Example: `should deserialize a serialized message split into two chunks {...2,3...}`. The failure is an assertion diff in which `test:stdout` events (`file: 'filetest'`) appear instead of the expected `test:diagnostic` event.
