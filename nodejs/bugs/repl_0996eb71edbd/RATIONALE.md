# Re-introduced bug: Ctrl+C ignored during REPL top-level await

## Bug
`prioritizedSigintQueue` is a `SafeSet`. The SIGINT handler iterated it with
`ArrayPrototypeForEach`, which is array-only (it reads `.length`), so on a Set it
iterates nothing. The prioritized SIGINT listener that rejects the pending
top-level-await promise with ERR_SCRIPT_EXECUTION_INTERRUPTED never ran, so Ctrl+C
did not interrupt `await new Promise(() => {})`.

## Hunks
1. `lib/repl.js`, `onSigInt`: replaced `for (const task of prioritizedSigintQueue) { task(); }`
   with `ArrayPrototypeForEach(prioritizedSigintQueue, (task) => task());`.
   This corresponds to the fix's last hunk (`ArrayPrototypeForEach(...)` -> `for...of`).
   It restores the broken iteration.

The fix's other hunk (PromisePrototypeFinally/Then chain -> async IIFE) is not
reversed. The release already has a different async IIFE with other changes, and
that rewrite was not what broke Ctrl+C. The Set iteration was.

## Failing test
`parallel/test-repl-top-level-await` fails (stable across runs). The "Testing Ctrl+C"
step never completes, and the test exits with:
`Mismatched noop function calls. Expected exactly 1, actual 0.`
(`main().then(common.mustCall())` is never reached.)
