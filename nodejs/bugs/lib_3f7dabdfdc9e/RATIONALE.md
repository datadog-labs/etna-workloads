# Re-introduced bug: `--check` on ES modules (fix 3f7dabdf)

**Bug.** `defaultGetFormat(url)` returns the format string directly (e.g. `'module'`), but `check_syntax.js` treated it as an object and destructured `{ format }`. That yields `undefined` for every file, so a `.mjs` file is never recognised as a module by `node --check`.

**Hunk (lib/internal/main/check_syntax.js).** Corresponds to the single implementation hunk of the fix. Upstream changed `const { format } = defaultGetFormat(url)` to `const format = defaultGetFormat(url)`. Today's code is `format = await defaultGetFormat(new URL(url))`, so I restored the old destructuring: `({ format } = await defaultGetFormat(new URL(url)));`. `format` is then always `undefined`, as before the fix.

**Failing test.** `sequential/test-cli-syntax-good` fails (`not ok`) in 2 of 2 runs. The failure message is `TypeError: Cannot destructure property 'format' of '(intermediate value)' as it is null.` at `check_syntax:67`: `defaultGetFormat` returns a string or null, never an object. The plain-string `.mjs` case also loses its format.
