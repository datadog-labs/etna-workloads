# Re-introduced bug: assert.deepEqual commutativity edge case (nodejs/node#37710)

**Bug.** When comparing objects, the key check only verified that the other object had the key as an *own* property, not that it was *enumerable*. With `a = { x: 1 }` and `b = { y: 1 }` plus non-enumerable `x` on `b`, `deepStrictEqual(b, a)` wrongly passed while `deepStrictEqual(a, b)` failed, so the result depended on argument order.

**Hunk.** `lib/internal/util/comparisons.js`, in `objEquiv` (unordered keys loop). The fix changed `hasOwn(val2, key)` to `propertyIsEnumerable(val2, key)` in `keyCheck`. The current code does this check through the property descriptor (`descriptor === undefined || descriptor.enumerable !== true`). I reduced it to `descriptor === undefined`, which is an own-property-only check, as before the fix.

**Failing test.** `parallel/test-assert-deep` fails, stable over repeated runs, with `AssertionError [ERR_ASSERTION]: Missing expected exception.` This comes from the regression block `assertNotDeepOrStrict(a, b)` with a non-enumerable `x`.
