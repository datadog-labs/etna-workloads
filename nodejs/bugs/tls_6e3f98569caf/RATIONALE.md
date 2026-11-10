# Re-introduced bug: tls.setMaxSendFragment abort

**Bug:** `TLSSocket.prototype.setMaxSendFragment` passed its argument straight to the native
handle without validation. The C++ side asserts `args.Length() >= 1 && args[0]->IsNumber()`,
so calling it with no argument or a non-number aborted the process instead of throwing
`ERR_INVALID_ARG_TYPE`. Non-int32 numbers (NaN, Infinity, 2**31) were also not rejected with
`ERR_OUT_OF_RANGE`.

**Change (lib/internal/tls/wrap.js; the code moved there from lib/_tls_wrap.js):**
1. Removed `validateInt32(size, 'size');` from `setMaxSendFragment`. This reverses the fix's
   second hunk, which added that call.
2. Removed `validateInt32` from the `internal/validators` destructuring import. This reverses
   the fix's first hunk, which added the import. It is now unused.

**Failing test:** `parallel/test-tls-max-send-fragment` fails in both runs. The process aborts with
`Assertion failed: args.Length() >= 1 && args[0]->IsNumber()` on `c.setMaxSendFragment()`.
