# Re-introduced bug: RegExp statics not reset before user code

Bootstrap code runs regexes, so `RegExp.$_`, `RegExp.lastMatch` etc. leak internal strings (e.g. "WeakRef") into user code. The fix runs `RegExpPrototypeExec(/^/, '')` before user code starts. The release already uses SideEffectFree* helpers elsewhere, so only the reset hunks are reverted.

Hunks (all re-expressed for today's code):
- lib/internal/main/run_main_module.js: removed the reset call and its primordials import (fix hunk of the same file).
- lib/internal/main/worker_thread.js: removed the reset call after `markBootstrapComplete()` (same fix hunk; the import stays because it is used elsewhere in the file).
- lib/internal/process/execution.js: removed the three reset calls (evalModule, evalScript, and the stdin/REPL-like paths) and the import (fix hunks in execution.js).

Failing test: parallel/test-startup-empty-regexp-statics (stable over repeated runs):
`The input did not match the regular expression /^undefined\r?\n$/. Input: 'WeakRefWeakRefWeakRefWeakRefundefined\n'`
