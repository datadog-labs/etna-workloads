# Re-introduced bug: CVE-2026-21714 (NGHTTP2_ERR_FLOW_CONTROL not handled)

## Bug
A peer can send a connection-level (stream 0) WINDOW_UPDATE whose increment
pushes the connection flow-control window past 2^31-1. nghttp2 then calls the
`on_invalid_frame_recv` callback with `NGHTTP2_ERR_FLOW_CONTROL` and terminates
the session internally by queueing GOAWAY(FLOW_CONTROL_ERROR). Before the fix,
Node never reported that condition to JavaScript, so the `Http2Session` was
never destroyed. It stayed alive with its socket open, which leaked memory and
let a remote attacker exhaust resources.

## Hunks

All changes are in `src/node_http2.cc`.

1. **`Http2Session::OnInvalidFrame`**: this hunk is the exact reverse of the
   fix's only implementation hunk. It removes
   `lib_error_code == NGHTTP2_ERR_FLOW_CONTROL ||` and the comment that explains
   it. Without it, the flow-control error no longer reaches
   `http2session_on_error_function`, so the session is not torn down from this
   callback.

2. **`Http2Session::OnFrameSent`**: the fix's hunk re-expressed for today's
   code. After the fix landed, the release added a general fallback: when
   nghttp2 sends a GOAWAY that Node did not start, `internal_goaway_sent_` is
   set and `SendPendingData` emits the session error. That fallback also caught
   the flow-control GOAWAY, which is why reverting hunk 1 alone no longer
   brings the bug back. The re-introduced condition
   `frame->goaway.error_code != NGHTTP2_FLOW_CONTROL_ERROR` stops that path from
   firing for this one case. The flow-control GOAWAY is again the only internal
   termination that never propagates an error to JS, which is the
   pre-fix behaviour. Other internal terminations (PROTO, etc.) are unaffected.

## Failing test
`parallel/test-http2-window-update-overflow` fails on 2 of 2 runs:

    not ok 1 parallel/test-http2-window-update-overflow
      severity: fail
      exitcode: -15
      stack: |-
        timeout

The server session never emits `error` or `close`, and the connection is never
ended. The session leaks, the server never closes, and the test times out.
