# Rationale

**Bug:** readline `Interface` methods `pause()`, `resume()` and `write()` did not validate that the interface was closed. Calling them after `close()` silently worked (re-emitting `pause`/`resume`, resuming the input stream) instead of throwing `ERR_USE_AFTER_CLOSE`. The REPL also redisplayed a prompt after close and called `resume`/ready callback after close.

**Hunks (all reverse of the fix, re-expressed for today's code):**
- `lib/internal/readline/interface.js`: removed the `if (this.closed) throw ERR_USE_AFTER_CLOSE` guards from `pause()`, `resume()`, `write()` (fix's three interface.js hunks).
- `lib/internal/repl/history.js`: the `flushHistory` handler (now in the history manager) unconditionally resumes and calls the ready callback, without the `!closed` check (fix's history.js hunk).
- `lib/repl.js`: prompt is redisplayed with `if (!e)` without the `!self.closed` check (fix's repl.js hunk).
- `lib/internal/main/repl.js`: restored `repl.pause()` in the exit handler when flushing (fix's main/repl.js hunk).

**Failing test:** `parallel/test-readline-interface` — the new "write/pause/resume after close" cases fail since `assert.throws` finds nothing thrown (missing expected ERR_USE_AFTER_CLOSE exception).
