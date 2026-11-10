# Rationale

**Bug.** Upstream, `FWrite` on Windows passed a length to `MultiByteToWideChar` that did not count a
null terminator, then wrote the wrong number of wide characters (`n-1`), so console debug output lost
its final character (the newline). In v26.13.0 the Windows branch already contains the post-fix code
(`WriteConsoleW(..., n, ...)`) and is not compiled on Linux, so a plain reversal changes nothing
observable. The same off-by-one is therefore re-expressed in the code path that runs on Linux.

**Hunk (src/debug_utils.cc, `simple_fwrite` lambda in `FWrite`).** It corresponds to the fix's
single hunk in `FWrite`, which changed the number of characters written to the console. Here the length
passed to `fwrite` is `str.size() - 1`, so the last character, the trailing `\n` of every debug line, is
dropped. The upstream bug also lost the last character of the output.

**Failing test.** `parallel/test-http2-debug` fails (`not ok`, stable across 2 runs). Its assertions
require `\r?\n` right after each debug message in stderr, and that newline is now missing.
