# Rationale

**Bug:** pipeTo()/pipeToSync() accept a writer destination, but also treated a writer that happens to have a `transform()` method as a transform and appended it to the transform pipeline. A destination with a `transform` method was therefore invoked as a transform (and not only used as a destination).

**Changes (lib/internal/streams/iter/pull.js):**
- `pipeToSync`: re-added `if (isTransformObject(writer)) ArrayPrototypePush(transforms, writer);` after option conversion (before pipeline creation). Corresponds to the fix's first hunk (removal in pipeToSync); the surrounding code changed (options converters), so it is placed right after `converters.PipeToSyncOptions`.
- `pipeTo`: re-added the same block before `const hasWriteSync`/`from(source)`, i.e. before the pipeline is built. Corresponds to the fix's second hunk (removal in pipeTo).

**Failing test:** `parallel/test-stream-iter-pipeto` fails (stable over 2 runs): `AssertionError: function should not have been called` at test-stream-iter-pipeto.js:161 (the writer's `transform: common.mustNotCall()` is invoked).
