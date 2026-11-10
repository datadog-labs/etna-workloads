# Re-introduced bug: assert.rejects() with validation object reports wrong stack/operator

**Bug.** When `assert.rejects()` (or `throws`) validates against a validation object and a key mismatches, `compareExceptionKey` used a hardcoded `Assert.prototype.throws` as `stackStartFn` and `'throws'` as operator. For `rejects` this strips the wrong frames (stack trace lacks `rejects`) and reports `operator: 'throws'` instead of `'rejects'`.

**Change (lib/assert.js, `compareExceptionKey`).** Corresponds to the fix hunk of the same function: the three uses of `fn` / `fn.name` (`stackStartFn` in the AssertionError, `err.operator`, and `operator` + `stackStartFn` in the `innerFail` call) were reverted to `Assert.prototype.throws` / `'throws'`. The `fn` parameter is kept (still passed by callers), which is the current-code equivalent of the old signature hunk. Other fix hunks (primitive-actual branch, call sites) left intact, since today's code differs; the primitive case still correctly uses `fn`.

**Failing test.** `parallel/test-assert-async` -> `not ok`; the new handler assertion on `err.operator` (expected `'rejects'`, got `'throws'`) fails for the `{ code: 'FOO' }` cases. Stable across two runs.
