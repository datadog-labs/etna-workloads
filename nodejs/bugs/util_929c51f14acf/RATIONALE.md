# Re-introduced bug: util.inspect getters that access `this` (nodejs/node#36045)

**Bug:** With `getters: true` and `showHidden: true`, util.inspect lists prototype getters
(via `addPrototypeProperties`). It evaluated them against the prototype object rather than the
inspected instance, so a getter like `get y() { return this._y; }` printed `[Getter: undefined]`
instead of `[Getter: 123]`.

**Changes (all in lib/internal/util/inspect.js), reverting the fix's hunks:**
1. `addPrototypeProperties`: the call to `formatProperty` no longer passes `main` (fix hunk 2).
2. `formatProperty` signature: removed the `original = value` parameter (fix hunk 3).
3. Getter invocation: `FunctionPrototypeCall(desc.get, original)` back to `value[key]`, where
   `value` is the prototype being walked (fix hunk 4; the fix's `ReflectApply` import hunk is
   not applicable since today's code uses FunctionPrototypeCall).
   This calls the getter with the wrong receiver.

**Failing test:** parallel/test-util-inspect-getters-accessing-this:
`Expected 'X { _y: 123, [y]: [Getter: 123] }'` but got `'X { _y: 123, [y]: [Getter: undefined] }'`.
