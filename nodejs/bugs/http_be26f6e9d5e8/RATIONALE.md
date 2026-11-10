# Bug
After an HTTP server connection socket's `on` wrapper unconsumes the parser, `addListener` was not aliased/restored, and `prependListener` was not restored: `socket.on !== socket.addListener`, and `addListener('data')` listeners never unconsume the parser, so data is lost.

# Changes (lib/_http_server.js)
1. Removed `socket.addListener = generateSocketListenerWrapper('addListener')` — corresponds to fix hunk `socket.addListener = socket.on` (today expressed as a separate wrapper). Without it addListener is the plain prototype method, differing from `on`.
2. Removed `this.addListener = ...` and `this.prependListener = ...` restores in the wrapper's `!this.parser` branch — correspond to the fix's restore lines in `socketOnWrap`.

# Failing test
parallel/test-http-server-unconsume: not ok (`actual: '', expected: 'hello world'`; data lost since addListener('data') doesn't unconsume). Stable over 2 runs.
