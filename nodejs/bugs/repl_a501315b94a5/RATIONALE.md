# Re-introduced bug: REPL ignores NO_COLOR / colors forced on

**Bug:** When a REPL is created with a terminal and `useColors` unset, `useColors` was computed as
`shouldColorize(output) || process.env.NODE_DISABLE_COLORS === undefined`. Since
`NODE_DISABLE_COLORS` is normally unset, this is always true, so `NO_COLOR` and a non-color-capable stream were ignored.

**Hunk (lib/repl.js, ~line 317):** corresponds to the single implementation hunk of the fix. The line
`options.useColors = shouldColorize(options.output);` is changed back to
`options.useColors = shouldColorize(options.output) || process.env.NODE_DISABLE_COLORS === undefined;`.
(The code had moved from the fix's line 302, but the reversal is the same.)

**Failing tests:** parallel/test-repl-envvars and parallel/test-repl-options (stable over 2 runs):
`actual: true, expected: false` for `useColors`.
