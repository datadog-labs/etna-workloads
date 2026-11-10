# Rationale

**Bug:** `ChildProcess.prototype.spawn` on a run-time spawn error (EACCES, EAGAIN, EMFILE, ENFILE, ENOENT) was meant to return early only for EMFILE/ENFILE (stdio can't be set up). The pre-fix code was too coarse: stdio was not set up for errors that should still have stdio (e.g. ENOENT), so `child.stdin/stdout/stderr/stdio` are undefined.

**Hunk (lib/internal/child_process.js):** corresponds to the fix's single implementation hunk (`if (err === UV_EMFILE || err === UV_ENFILE) return err;`). A plain reversal (`err !== UV_ENOENT`) no longer fails any test, since today ENOENT still sets up stdio. I instead made the early return unconditional for all run-time errors, so stdio is skipped for ENOENT/EACCES/EAGAIN as well — the same defect (wrong check deciding when stdio is skipped).

**Failing test:** parallel/test-child-process-spawn-error — `assert.notStrictEqual(enoentChild.stdin, undefined)` fails (stdin is undefined). sequential/test-child-process-emfile still passes. Failure was stable across repeated runs.
