# Re-introduced bug: AbortController/AbortSignal lack Symbol.toStringTag

Before the fix, `AbortController.prototype` and `AbortSignal.prototype` had no `Symbol.toStringTag`.
`Object.prototype.toString.call(new AbortController())` gave `[object Object]` instead of
`[object AbortController]`, and util.inspect showed `[AbortSignal [EventTarget]]`.

## Changes (lib/internal/abort_controller.js)
- Hunk 1 (fix: `ObjectDefineProperty(AbortSignal.prototype, SymbolToStringTag, ...)`): removed that definition, so signals have no tag.
- Hunk 2 (fix: same for `AbortController.prototype`): removed it, so controllers have no tag.
- Hunk 3 (fix: added `ObjectDefineProperty`/`SymbolToStringTag` to primordials destructuring): removed the now-unused imports.
  In today's tree the code also uses `__proto__: null` and `kEnumerableProperty`, so a direct reversal does not apply.

## Failing tests
- parallel/test-abortcontroller: `actual: '[object Object]', expected: '[object AbortController]'`, and
  `'AbortController { signal: [AbortSignal [EventTarget]] }'` vs `'AbortController { signal: [AbortSignal] }'`.
- parallel/test-eventtarget-memoryleakwarning: warning says `[AbortSignal [EventTarget]]` instead of `[AbortSignal]`.
Both fail stably across two runs.
