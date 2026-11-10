# Re-introduced bug: HTTP2 memory leak (CVE-2025-23085)

Bug: when a peer closes prematurely, or nghttp2 rejects a frame with ERR_PROTO, the native
Http2Session never reports the error or closes, so the session is leaked. Also, a frameError closes
the session immediately, before a pending GOAWAY with the correct code can arrive.

Hunks:
1. src/node_http2.cc `OnInvalidFrame`: removed `lib_error_code == NGHTTP2_ERR_PROTO` from the emit-error condition
   (fix added it). ERR_PROTO is no longer surfaced, so the session isn't released and no 'error' is emitted.
2. src/node_http2.cc `OnFrameNotSent`: restored unconditional `return 0` for SESSION_CLOSING/STREAM_CLOSED/STREAM_CLOSING
   (fix skips it for GOAWAY frames). A failed GOAWAY no longer forces the close from our side.
3. lib/internal/http2/core.js `onFrameError`: restored the synchronous `stream.close(code); session.close()`
   instead of deferring with setImmediate (fix deferred it). Debug() additions are not behavioral and were skipped.

Failing tests:
- parallel/test-http2-connect-method-extended-cant-turn-off (expected client 'error' ERR_HTTP2_ERROR never emitted)
- parallel/test-http2-options-max-headers-block-length (stream error is FRAME_SIZE_ERROR instead of REFUSED_STREAM)
Failure is stable across runs.
