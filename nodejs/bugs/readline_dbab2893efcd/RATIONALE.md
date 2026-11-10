# Re-introduced bug: pre-aborted signal in readline question

**Bug:** `rl.question()` with an already-aborted `AbortSignal` did not bail out. The callback form still queued the question (resuming the interface and writing the prompt), and the promisified form did not reject with `AbortError` up front.

**Changes (lib/readline.js only):**
1. In `Interface.prototype.question`, removed the `if (options.signal.aborted) return;` check. This corresponds to the fix's first hunk, which added that check.
2. In `Interface.prototype.question[promisify.custom]`, removed the early `PromiseReject(new AbortError(...))` for an aborted signal. This corresponds to the fix's second hunk.
3. Removed the `PromiseReject` import, which is now unused. This corresponds to the fix's import hunk.

**Failing test:** `parallel/test-readline-interface` fails on both runs. The message is `AssertionError [ERR_ASSERTION]: function should not have been called at test/parallel/test-readline-interface.js:1151`. That is the pre-aborted `rli.on('resume', common.mustNotCall())` case.
