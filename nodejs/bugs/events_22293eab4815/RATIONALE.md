# Re-introduced bug: AbortSignal can be constructed manually

**Bug.** `new AbortSignal()` (e.g. `new ac.signal.constructor()`) should throw `TypeError: Illegal constructor`. Before the fix the constructor was public, so users could build a signal that no AbortController controls.

**Change (lib/internal/abort_controller.js, one hunk).** Removed the `if (dontThrowSymbol !== kDontThrowSymbol) throw new ERR_ILLEGAL_CONSTRUCTOR();` guard from `AbortSignal`'s constructor. This corresponds to the fix's added `constructor() { throw new TypeError('Illegal constructor'); }` (plus the `createAbortSignal` helper). Today's code uses a private-symbol argument as the guard instead of a throwing constructor plus a factory, so dropping the guard restores the old behaviour: any caller can construct a signal. Internal callers still work.

**Failing test.** `parallel/test-abortcontroller` fails ("not ok"): the new check `throws(() => new ac.signal.constructor(), /Illegal constructor/)` finds no exception thrown.
