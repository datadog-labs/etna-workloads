# Bug
`pipeline(Buffer.from('abc'), ...)` fails: Buffers have a `write` method, so without an `on` check they are mistaken for node streams (issue #37731).

# Change (lib/internal/streams/utils.js)
Corresponds to the fix's hunks in `isReadable`/`isWritable` (now `isReadableNodeStream`, `isWritableNodeStream`, and `isNodeStream`): removed the `typeof obj.on === 'function'` requirement from all of them, so only `pipe`/`write` are checked, as before the fix.

# Failing test
parallel/test-stream-pipeline fails (the Buffer-as-first-argument case at the end of the file), since the Buffer is treated as a stream rather than an iterable source.
