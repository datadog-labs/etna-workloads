# Re-introducing: fs.promises.readFile stops before EOF on unknown-size files

**Bug.** For files whose size is unknown (pipes, /dev/stdin, size 0), `fs.promises.readFile` treated a short read as EOF, so it returned only the first chunk (e.g. "Hello\n" from `(echo Hello; sleep 0.5; echo World) | node`) instead of reading until a 0-byte read.

**Hunks.**
1. `lib/internal/fs/promises.js` (`readFileHandle`): reverses the fix's hunks. The `noSize` variable is removed, and the early-return condition is back to `bytesRead !== buffer.length && !chunkedRead`. Intermediate chunks are pushed/decoded unsliced (the `readBuffer` subarray is removed). `size === 0` is restored in the non-encoding branch. This alone doesn't trigger the bug today, because `readFile` now reads small/unknown-size files in C++ via `ReadFileJob`.
2. `src/node_file.cc` (`ReadFileJob::DoThreadPoolWork`): this is the current-code equivalent of the fix's `!noSize` condition. For size-0 files, a short read now ends the loop instead of continuing until `r == 0`. That brings back the old behaviour of treating a short read as EOF.

**Failing test.** `parallel/test-fs-readfile-eof` fails on both the encoding and non-encoding cases, e.g. `AssertionError: expected to read(with encoding): 'Hello\nWorld\n' but got: 'Hello\n'`. The failure was stable over 2 runs.
