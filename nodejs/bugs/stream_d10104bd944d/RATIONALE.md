# Rationale

**Bug:** In `fromList()` (lib/internal/streams/readable.js), decoded (string) mode, when `n` is shorter than the remaining data and lands exactly on a chunk boundary check, the code compared `n` to `buf.length` (the number of chunks in the array) instead of the current chunk's length. When `n` happened to equal the chunk count, the whole chunk was consumed instead of just `n` characters, over-consuming data and corrupting readable state (can lead to `TypeError` when mixing `setEncoding()` and `read(n)`).

**Hunk:** `lib/internal/streams/readable.js`, in the decoded branch of `fromList`: `if (n === strLength)` -> `if (n === buf.length)`. This corresponds to the fix's single hunk (`n === buf.length` -> `n === str.length`); in today's code `str.length` is cached as `strLength`, so the reversal is re-expressed against that variable.

**Failing test:** `parallel/test-stream2-read-correct-num-bytes-in-utf8` fails (stable over 2 runs):
`actual: 'abcdefgh', expected: 'abcde'` (read(5) after pushing 'abc','defgh' returns everything since n(2 remaining)==buf.length(2)).
