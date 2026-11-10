# Re-introduced bug: pipeline() with stdio destination never completes

**Bug.** stdout/stderr are never really closed, so `pipe()` does not end them. Without special handling, `pipeline(src, process.stdout, cb)` never calls `cb`, because the destination never finishes.

**Change (lib/internal/streams/pipeline.js, `pipe()` helper).** The fix added `ret.on('end', () => stream.end())` for `process.stdout`/`process.stderr`. The release now ends the destination in the `if (end)` block, using `endFn` and `isReadableFinished`. I made that block skip ending when `dst` is `process.stdout` or `process.stderr`. This restores the pre-fix behaviour: stdio destinations are never `end()`ed, so the pipeline never finishes.

**Failing test.** `parallel/test-stream-pipeline-process` fails. The child process exits with code 1, because the pipeline callback is never called and `common.mustCall` fails. The parent's `assert.ifError(err)` then throws.
