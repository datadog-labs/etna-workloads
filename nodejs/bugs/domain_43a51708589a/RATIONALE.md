# Re-introduced bug: domain error handlers run inside their own domain

**Bug.** A domain's 'error' handler ran with that domain still active (and on the domains stack). An emitter created in the handler, or an exception thrown from it, could re-enter the same handler recursively.

**Hunks (all in lib/domain.js)**
1. `Domain.prototype._errorHandler`: removed the `while (exports.active === this) this.exit();` loop, which is the fix's "pop adjacent duplicates" hunk. The handler again runs with its domain on the stack.
2. Same function: top-level check changed back from `stack.length === 0` to `stack.length === 1`, and the comment restored. This matches the fix's change of the same line. The domain is no longer popped, so the top-level domain is the one remaining entry.
3. Same function, catch block: restored `if (this === exports.active) stack.pop();` before `updateExceptionCapture()`. The fix removed this double-exit guard.
4. `EventEmitter.prototype.emit` (type 'error' with a domain): removed the code that saved the stack, popped the domain and its duplicates, and set the active domain to the parent. Also removed the restore after `domain.emit('error', er)`. The handler now runs with the domain active, as before the fix.

**Failing tests** (stable over 2 runs; all four oracle cases fail)
- test-domain-thrown-error-handler-stack: "domains stack length should be 1 but is 2"
- test-domain-emit-error-handler-stack: "expected domains stack length of 0, but instead is 1"
- test-domain-top-level-error-handler-clears-stack: "domains stack length should be 0, but instead is: 1"
- test-timers-reset-process-domain-on-throw: the assertion on `process.domain` fails (expected undefined).
