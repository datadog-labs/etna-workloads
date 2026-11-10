# Re-introduced bug: readline carriage return split across chunks (nodejs #45992)

**Bug.** `lineEnding` is a global (`/g`) regex whose `lastIndex` is stateful. When a buffered partial line was joined with a new chunk, the pre-fix code re-ran `RegExpPrototypeExec(lineEnding, string)` without resetting `lastIndex`. The search then began after the match found in the chunk, so a `\r` at the join point was skipped. Input `'a\nb'` then `'\r\n'` therefore emitted the line `'b\r'` with a stray carriage return.

**Change** (`lib/internal/readline/interface.js`, `[kNormalWrite]`). The release now splits only the new chunk, so the old code does not apply directly. I restored the old flow:
- `lineEnding.lastIndex = 0` before the first `exec` on the chunk: this emulates the old loop that drained the regex to `null`, so the state is clean on entry.
- If the chunk contains an ending and a buffer exists, join the buffer and chunk and re-`exec` with no `lastIndex = 0` reset. This is the line the fix added (the fix hunk's `lineEnding.lastIndex = 0`), and its absence brings back the stale search position.
- The first line is taken from `newPartContainsEnding.index` (this replaces `buffer + lines[0]`), so the stale match position is used.

**Failing test.** `parallel/test-readline-carriage-return-between-chunks` fails with `AssertionError: 1 !== 0` (a line contained `\r`). It failed on repeated runs, and the other `test-readline*` tests pass.
