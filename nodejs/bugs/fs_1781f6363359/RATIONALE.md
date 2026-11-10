# Rationale

**Bug:** `FileHandle.readableWebStream()` created a bytes stream only if the caller explicitly passed `{ type: 'bytes' }`. By default it built a non-byte stream via `newReadableStreamFromStreamBase`. `getReader({ mode: 'byob' })` therefore failed on the default stream, and a non-"bytes" type silently selected different stream semantics instead of emitting a warning.

**Change (lib/internal/fs/promises.js, one hunk in `readableWebStream`):** This corresponds to the fix's main hunk, which removed the `type !== 'bytes'` branch that used the StreamBase adapter and always built the `type: 'bytes'` ReadableStream.
- The default `type` is now `undefined` instead of `'bytes'`.
- The "non-bytes has no effect" warning is removed.
- Any type other than `'bytes'` goes back to `newReadableStreamFromStreamBase`, with an `ondone` that keeps today's autoClose handling.
- The bytes stream is built only when `type === 'bytes'`.

**Failing test:** `parallel/test-filehandle-readablestream` fails. The default stream is not a byte stream, so the `getReader({ mode: 'byob' })` case throws, and the warning test fails because no warning is emitted.
