# Re-introduced bug: integer overflow in inspector.open()

**Bug.** `inspector.open(port)` passed any uint32 port straight to the native `Open()`, which stores it in a 16-bit port field. A port such as 99999 was not rejected, so it overflowed or was silently accepted.

**Hunks.**
1. `lib/inspector.js`: removes the `if (isUint32(port)) validateInt32(port, 'port', 0, 65535)` guard from `inspectorOpen()`. It also removes the `isUint32` and `validateInt32` imports, which are now unused. This reverses the fix's lib hunks (imports plus the guard). It restores the old behaviour of not range-checking the port in JS.
2. `src/inspector_js_api.cc`: removes `CHECK_LE(port, std::numeric_limits<uint16_t>::max())` in `Open()`. This reverses the fix's C++ hunk, so the native side no longer asserts the port range.

The plain reversal did not apply because of code drift. The guard now sits before the `host` loopback warning, so I removed it by hand.

**Failing test.** `parallel/test-inspector-open-port-integer-overflow` gives "not ok" in 2 of 2 runs. `inspector.open(99999)` no longer throws `ERR_OUT_OF_RANGE`, so `assert.throws` fails. TAP output shows the expected message: `The value of "port" is out of range. It must be >= 0 && <= 65535. Received 99999`.
