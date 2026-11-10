# Re-introduced bug: REPL `terminal` default only applied to the standalone REPL

**Bug.** The documented default for the `terminal` option (`output.isTTY`) was applied only when the REPL ran as the standalone program (lib/internal/repl.js). A `REPLServer` created via the public API with a TTY output and no `terminal` option got `terminal = false`, so colors were not enabled by default either.

**Hunks.**
1. `lib/repl.js`: removed the `if (options.terminal === undefined) options.terminal = options.output.isTTY;` block. Corresponds to the fix's added block in the REPLServer constructor that centralises the terminal default. Without it, `terminal` is `false` for non-standalone REPLs, and the `useColors` default (only evaluated when terminal is true) is skipped.
2. `lib/internal/repl.js`: restored `terminal: process.stdout.isTTY` in the default opts of `createRepl`. This corresponds to the fix removing that line. The default now lives only in the standalone path, as before the fix.

**Failing test.** `parallel/test-repl-colors` fails (`repl2.writer.options.colors`: actual `false`, expected `true`). `test-repl-envvars` still passes.
