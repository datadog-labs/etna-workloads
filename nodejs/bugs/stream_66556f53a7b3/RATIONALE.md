# Re-introduced bug: cloned webstreams keep the process alive (nodejs/node#51526)

Bug: the MessagePort used by a transferred/cloned ReadableStream/WritableStream was never
unref'd, so setting `port.onmessage` kept the event loop alive and the process never exited
after `structuredClone([rs, ws], {transfer})`.

Change (lib/internal/webstreams/transfer.js, 2 hunks):
- Removed `port.unref()` at the end of the `CrossRealmTransformReadableSource` constructor
  (fix hunk: added `port.unref()` there).
- Removed `port.unref()` at the end of the `CrossRealmTransformWritableSink` constructor
  (fix hunk: added `port.unref()` there).
The `unref` flag/`port.ref()` logic in pull()/write() stays; it is harmless without the unref.
The other fix hunks (constructor args, writablestream setPromiseHandled) are not needed to
restore the hang.

Failing test: parallel/test-webstreams-clone-unref — times out (120s, "not ok"), stable over
two runs. test-whatwg-webstreams-transfer still passes.
