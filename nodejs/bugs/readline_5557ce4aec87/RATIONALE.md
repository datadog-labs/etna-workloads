# Rationale

**Bug:** In `readline/promises`, a pending `rl.question()` promise never settles when the user aborts with Ctrl+C or Ctrl+D (with no SIGINT listener / empty line). The interface closes, but the promise stays unresolved.

**Change (lib/internal/readline/interface.js):** the fix added `this[kQuestionReject]?.(new AbortError('Aborted with Ctrl+C'))` after `this.close()` in the Ctrl+C case and the equivalent `Aborted with Ctrl+D` call in the Ctrl+D case of the keypress handler. I removed both calls (re-expressed for the current code, where the handler sits at a different location). That restores the old behaviour: the interface closes but the question promise is never rejected. The `kQuestionReject` symbol, its export, the `AbortError` import and the `this[kQuestionReject] = reject` assignment in lib/readline/promises.js are left in place. They are harmless without the calls, and I didn't want to break the build.

**Failing test:** `parallel/test-readline-promises-interface` reports `not ok` on both runs. The new "Aborting a question with ctrl+C/ctrl+D" cases use `assert.rejects(...).then(common.mustCall())`. The promise never settles, so `mustCall` fails at exit. I did not capture the exact failure message.
