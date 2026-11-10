# Rationale

**Bug:** `util.format('%s', obj)` decided whether to call `String(obj)` using a heuristic that only looked at `obj.constructor.prototype` for an own `toString`. A user-defined `toString` declared further up the prototype chain (e.g. on a super class, or when `constructor` is missing, null or overwritten) was missed, so the object was inspected instead. It also read `obj.constructor`, which triggers getters.

**Change (lib/internal/util/inspect.js, one hunk):** in `formatWithOptionsInternal`, case `%s`, the call `!hasBuiltInToString(tempArg)` is replaced by the old inline condition (own `toString`, or `constructor` that is non-builtin with `constructor.prototype` owning `toString`). This corresponds to the fix's hunk that removed the inline condition and used `hasBuiltInToString`. The `hasBuiltInToString` helper is left in place, now unused (the fix's hunk adding it is not reversed, to stay minimal).

**Failing test:** `parallel/test-util-format` fails ("not ok") with `AssertionError [ERR_ASSERTION]: Expected values to be strictly equal` in the new subclassing cases (e.g. `class B extends Foo {}` expecting 'Bar'). It failed in both runs.
