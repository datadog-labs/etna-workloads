# Re-introduced bug: worker file extension check

**Bug.** `new Worker(filename)` rejected any string filename whose extension was not `.js`, `.mjs` or `.cjs`. It threw `ERR_WORKER_UNSUPPORTED_EXTENSION`. This broke extensionless and custom-extension entry points (nodejs/node#39124).

**Hunks.**
- `lib/internal/errors.js` re-adds the `ERR_WORKER_UNSUPPORTED_EXTENSION` definition. This reverses the fix's errors.js hunk.
- `lib/internal/worker.js` re-adds the error to the destructured imports. This reverses the import hunk.
- `lib/internal/worker.js` re-adds the extension check in the string-filename branch. This reverses the check hunk. Today's code differs from the pre-fix code: the old check ran after the path was validated and resolved. A plain reversal at that spot leaves every oracle case passing, because none of them uses an unsupported extension on a valid path. So the check now runs before the absolute/relative path test. Inputs such as `relative_no_dot` and `file:///file_url` have no supported extension, so they throw the extension error instead of `ERR_WORKER_PATH`.

**Failing test.** `parallel/test-worker-unsupported-path` fails on every run (two runs). It expects `ERR_WORKER_PATH` but gets `ERR_WORKER_UNSUPPORTED_EXTENSION`. The TAP output reads `+ code: 'ERR_WORKER_UNSUPPORTED_EXTENSION'`, `- code: 'ERR_WORKER_PATH'`.
