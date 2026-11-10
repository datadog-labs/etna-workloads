# Re-introduced bug: ANSI escape codes used when TERM=dumb

**Bug.** With `TERM=dumb`, the console behaved as if the terminal supported ANSI codes: `console.log`/`console.dir` colorized inspected output (e.g. `{ foo: \x1b[32m'bar'\x1b[39m }`), and `console.clear()` emitted cursor/clear escapes on a TTY.

**Hunks.**
1. `lib/internal/console/constructor.js` `clear()`: removed `&& process.env.TERM !== 'dumb'`. This is a direct reversal of the fix's only hunk.
2. `lib/internal/tty.js` `getColorDepth()`: removed the `env.TERM === 'dumb'` clause. This has no counterpart in the fix diff. Today's release also turns off colors for dumb terminals here, so hunk 1 alone does not change what the test sees. This hunk re-expresses the same defect (dumb terminal gets ANSI) for the current code.

**Failing test.** `pseudo-tty/console-dumb-tty` fails with:
`match failed line=0 expect=^\{\ foo:\ 'bar'\ \}$ actual={ foo: [32m'bar'[39m }`
It failed on two consecutive runs.
