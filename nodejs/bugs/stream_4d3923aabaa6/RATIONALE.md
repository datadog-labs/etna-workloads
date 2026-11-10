# Re-introduced bug: cloned webstreams keep the process alive

**Bug.** The internal MessagePorts used when a ReadableStream/WritableStream is cloned or transferred were not unref'd, so a cloned stream that was never fully consumed kept the process from exiting.

**Change.** In `lib/internal/webstreams/transfer.js`, I removed `port.unref()` from the constructors of `CrossRealmTransformReadableSource` and `CrossRealmTransformWritableSink`. These correspond to the two `transfer.js` hunks of the fix.

**Not changed.** The `port1.unref()`/`port2.unref()` calls that the fix added in `readablestream.js` and `writablestream.js` `[kTransferList]` are not present in the release. Upstream code moved on, and those hunks have nothing to revert. The release already behaves like the pre-fix code there.

**Result.** `parallel/test-webstreams-clone-unref` fails, in two runs: the process never exits and the test times out. `parallel/test-whatwg-webstreams-transfer` still passes.
