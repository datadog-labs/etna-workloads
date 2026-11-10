# Bug
The REPL passed `pathToFileURL(process.cwd())` (a directory URL) as the referrer for dynamic `import()`. The ESM loader needs a path inside the directory, so relative imports resolved against the cwd's parent (e.g. `./message.mjs` in `fixtures/es-modules` looked in `fixtures/`).

# Change (lib/repl.js, one hunk)
Corresponds to the fix's single lib hunk: `pathToFileURL(path.join(process.cwd(), 'repl')).href` is changed back to `pathToFileURL(process.cwd()).href` for `parentURL` (called `pwd` upstream; the variable was renamed in later code). The stale comment about `/repl` was left in place.

# Failing test
parallel/test-repl-import-referrer fails (twice): ERR_MODULE_NOT_FOUND "Cannot find module .../test/fixtures/message.mjs imported from .../test/fixtures/es-modules" instead of `[Module: null prototype] { message: 'A message' }`.
