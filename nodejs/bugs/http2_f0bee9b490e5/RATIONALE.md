# Re-introduced bug: no default maxConcurrentStreams (f0bee9b490e5)

**Bug.** Node did not report a default for `maxConcurrentStreams` (NGHTTP2_DEFAULT_MAX_CONCURRENT_STREAMS, 0xffffffff). `http2.getDefaultSettings()` lacked it, and `getPackedSettings()` with defaults omitted it. The `DEFAULT_SETTINGS_MAX_CONCURRENT_STREAMS` binding constant was not exported. JS also limited stream IDs/maxConcurrentStreams to 2**31-1 instead of 2**32-1.

**Hunks.**
- `src/node_http2.cc` `Http2Settings::RefreshDefaults` (fix: add buffer entry and flag bit for MAX_CONCURRENT_STREAMS). Today the defaults come from the `HTTP2_SETTINGS` X-macro, so I reset the entry to 0 and clear its flag bit after the loop.
- `src/node_http2.h` (fix: `NODE_DEFINE_CONSTANT(constants, DEFAULT_SETTINGS_MAX_CONCURRENT_STREAMS)` and the `#define`). Today the constant is in a V-list of exported constants, so I removed it from that list. The constexpr definition stays, since the loop macro references it.
- `lib/internal/http2/core.js`: `kMaxStreams` back to `(2 ** 31) - 1`.

**Failing tests.** test-http2-binding, test-http2-client-setNextStreamID-errors (`must be > 0 and <= 2147483647` vs expected `4294967295`), test-http2-getpackedsettings. test-http2-client-settings-before-connect still passes.
