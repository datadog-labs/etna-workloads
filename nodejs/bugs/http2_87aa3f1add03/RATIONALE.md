# Rationale

**Bug:** In `Http2Session::HandleDataFrame`, a 0-length DATA frame without END_STREAM was always treated as a fatal error (callback returns 1), instead of going through the invalid-frame counter that tolerates up to `maxSessionInvalidFrames` of them. A single such empty frame therefore kills the session.

**Hunk (src/node_http2.cc, HandleDataFrame):** corresponds to the fix's only implementation hunk. The release version of the fix also sets `custom_recv_error_code_ = "ERR_HTTP2_TOO_MANY_INVALID_FRAMES"` inside the counter check. I replaced the whole `if (invalid_frame_count_++ > max_invalid_frames) {...}` block with the unconditional `return 1;` that existed before the fix.

**Failing test:** `parallel/test-http2-empty-frame-without-eof` fails (`not ok`) in two consecutive runs. With `maxSessionInvalidFrames: 2` the client now errors, so `common.mustNotCall()` on the error handlers is triggered.
