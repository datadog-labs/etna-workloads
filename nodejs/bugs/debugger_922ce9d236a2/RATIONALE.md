# Re-introduced bug: plain object `exec { a: 1 }` in debugger REPL

**Bug:** In `node inspect`, `exec { a: 1 }` (or `p { a: 1 }`) sent the text `{ a: 1 }` to the inspector unchanged, so it was parsed as a block statement with a label, not an object literal. The result was `1` rather than `{ a: 1 }` (nodejs/node#46808).

**Change (lib/internal/debugger/inspect_repl.js, `prepareControlCode`):** This corresponds to the fix's inspect_repl.js hunk. I removed the `isObjectLiteral(input)` check that wraps the input in parentheses, and restored `exec(${JSONStringify(match[1])})` using the raw match. I also removed the now-unused `isObjectLiteral` import, which corresponds to the fix's import hunk. The fix's utils.js and repl.js hunks only extracted the helper. `isObjectLiteral` is still used by lib/repl.js, so I left those hunks alone.

**Failing test:** `parallel/test-debugger-exec` reports `not ok`. The new assertion `assert.match(cli.output, /\{ a: 1 \}/)` fails after `exec { a: 1 }`. I ran it twice and it failed both times. I did not read the failure message itself, only the TAP `not ok` line.
