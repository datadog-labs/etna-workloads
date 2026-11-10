# Rationale

**Bug:** with `--tls-keylog`, the code that registers the `keylog` listener (which appends to the file) and the `enableKeylogCallback()` call sat inside the `if (warnOnTlsKeylog)` block. That block runs only once, when the warning is emitted. So only the first TLS socket in the process was logged. Every later socket, client or server, was not.

**Note on the file:** the code now lives in `lib/internal/tls/wrap.js`, not `lib/_tls_wrap.js`. The release has already applied the fix's other hunks: the unified `onkeylog` and the `keylogNewListener` registration. Only the `--tls-keylog` hunk could be re-expressed.

**Hunk (`lib/internal/tls/wrap.js`, `if (tlsKeylog)` block):** this corresponds to the fix's hunk `@@ -731,17 +720,16 @@`. I moved `ssl.enableKeylogCallback()` and the `this.on('keylog', ...appendFile...)` registration back inside `if (warnOnTlsKeylog)`. That is the pre-fix layout, so only the first socket gets logged.

**Failing test:** `parallel/test-tls-enable-keylog-cli` fails, and I ran it twice with the same result. The test expects two identical lines in the keylog file, one from the client and one from the server. With the bug only one socket is logged, so the line-count assertion fails. I did not capture the exact assertion message; the TAP run showed `not ok` only.
