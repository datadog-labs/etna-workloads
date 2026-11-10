# Rationale

Bug: aborting a child via AbortSignal always emitted an `AbortError`, even when the kill
did not happen (child already exited but 'close' not yet fired), because the abort listener
was only removed on 'close' rather than 'exit' and the error was emitted unconditionally.

Hunks (lib/child_process.js; the original spawnWithSignal no longer exists, spawn handles the signal now):
1. `abortChildProcess`: removed the `if (child.kill(killSignal))` guard, so `AbortError` is emitted
   unconditionally (fix hunk: adds abortChildProcess with the guard; old code emitted always).
2. In `spawn`, the abort listener disposal moved from `child.once('exit', ...)` back to
   `child.once('close', ...)` (fix hunk: 'close' -> 'exit'), so an abort between exit and close
   still fires and emits an error.

Failing tests: parallel/test-child-process-fork-abort-signal and
parallel/test-child-process-spawn-controller (the "abort after exit but before close" cases
hit `common.mustNotCall()` on 'error'). Failure is stable across runs.
