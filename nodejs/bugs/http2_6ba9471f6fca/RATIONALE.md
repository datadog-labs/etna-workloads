# Re-introduced bug: http2 `remoteSettings` returns stale settings

**Bug.** After the peer sends a new SETTINGS frame, `session.remoteSettings` (and the
`'remoteSettings'` event argument) returned the previously cached settings object instead of the
latest values (nodejs/node#29764).

**Why the plain reversal was not enough.** Today the cache is also guarded by a native bitfield
bit, `kSessionRemoteSettingsIsUpToDate`. C++ clears that bit on every non-ACK SETTINGS frame, so
removing only the JS line still produced fresh values. Both invalidation paths had to go.

## Hunks
1. `lib/internal/http2/core.js`, `onSettings()`: removed `session[kRemoteSettings] = undefined;`.
   This is the fix's single implementation hunk, reversed. The cached object is no longer dropped
   when new settings arrive.
2. `src/node_http2.cc`, `Http2Session::HandleSettingsFrame()`: removed
   `js_fields_->bitfield &= ~(1 << kSessionRemoteSettingsIsUpToDate);`. This is the modern
   equivalent of the same invalidation, so the `remoteSettings` getter keeps returning the cached
   object. Without this hunk the old defect is not reachable.

## Failing test
`parallel/test-http2-session-settings` fails in both runs. The client's second `remoteSettings`
event reports the old value:
`AssertionError: Expected values to be strictly equal: 4294967295 !== 2`
(at test-http2-session-settings.js:109).
