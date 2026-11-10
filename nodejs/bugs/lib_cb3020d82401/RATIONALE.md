# Re-introduced bug: readline Interface ignores input stream 'error'

Bug: readline.Interface did not listen for 'error' on its input stream, so an input error (e.g. ENOENT from fs.createReadStream) was never forwarded as an 'error' event on the Interface. It surfaced as an uncaught exception on the stream, and `rl.on('error')` and `for await` could not catch it.

The code moved to lib/internal/readline/interface.js. The async iterator now uses EventEmitter.on, which handles 'error' itself, so the fix's `errorListener` hunk has no counterpart today. It is not touched.

Hunks (all in lib/internal/readline/interface.js):
1. Removed `function onerror(err){ self.emit('error', err); }` (fix hunk 1).
2. Removed `input.on('error', onerror);` (fix hunk 3) – the actual forwarding.
3. Removed `input.removeListener('error', onerror)` in onSelfCloseWithoutTerminal and onSelfCloseWithTerminal (fix hunks 3/4), since the listener no longer exists.

Failing test: parallel/test-readline-input-onerror (failed on both runs) with an uncaught
`Error: ENOENT: no such file or directory, open '.../test/parallel/file.txt'` thrown from emitErrorNT.
