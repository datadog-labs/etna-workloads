# Re-introduced bug: reentrant Parser::Execute (upstream b970634cfe42)

**Bug.** The HTTP parser tracked the "current buffer" in a `Local<Object>` member and passed `(buffer, start, len)` to the JS `kOnBody` callback. It also guarded `Execute` with `execute_depth_` and `CHECK_EQ(execute_depth_, 0)`. If a JS callback (e.g. `information` for a 100-continue) caused the parser to be re-entered via `Execute`, the process aborted on that CHECK. Pause requests made during execute were also deferred through `pending_pause_`.

## Hunks
`src/node_http_parser.cc` (each corresponds to the fix's hunk of the same area, reversed):
- `MemoryInfo`: replaced `SET_NO_MEMORY_INFO()` with tracking of `current_buffer_`.
- `on_body`: restored the old version. It uses `current_buffer_` (copying it when empty) and calls the callback with `(buf, offset, length)`. The fix replaced this with a per-chunk `Buffer::Copy` and one argument.
- Static `Execute`/`Finish`: restored the CHECKs that `current_buffer_` is empty, and set `current_buffer_ = args[0]`.
- `Pause`: restored the `execute_depth_` check that defers the pause through `pending_pause_`.
- `OnStreamRead`: restored `current_buffer_.Clear()` before `Execute`.
- `Parser::Execute`: restored `CHECK_EQ(execute_depth_, 0)` and the `execute_depth_++/--` around llhttp. Restored `current_buffer_.Clear()` after it.
- `MaybePause`: restored `CHECK_NE(execute_depth_, 0)`.
- Members: restored `current_buffer_` and `execute_depth_`.

`lib/_http_common.js`: `parserOnBody(b, start, len)` is restored, slicing the buffer when `len > 0`.

## Failing tests
- `parallel/test-http-parser` fails with an AssertionError (strict equal). The test's `onBody(buf)` now receives the whole buffer instead of only the body chunk.
- `parallel/test-http-parser-multiple-execute` fails (not ok). The reentrant Execute hits the CHECK and aborts.
