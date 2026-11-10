# Rationale

**Bug:** deepStrictEqual's constructor check (`objectComparisonStart` in lib/internal/util/comparisons.js) compared `val1.constructor !== val2.constructor` directly, and only compared prototypes when `constructor` was undefined. Objects with an own `constructor` property (e.g. `{constructor: {name:'Foo'}}`) were therefore compared by that property value rather than by prototype, so objects with different prototypes could be deemed equal (or equal-prototype ones unequal).

**Hunk:** the single hunk in `objectComparisonStart` corresponds to the fix's hunk of the same function. The well-known-constructor fast path / `hasOwn(val1,'constructor')` fallback was replaced with the pre-fix condition (constructor mismatch, or undefined constructor with differing prototypes). The wellKnownConstructors set is left in place (now unused), as the fix's other hunks are only supporting additions; the inspect.js hunks are unrelated to the behaviour.

**Failing test:** parallel/test-assert-deep ("not ok"): the subtests 'Own property constructor properties should check against the original prototype' and 'Inherited null prototype without own constructor properties ...' fail (e.g. `assertNotDeepOrStrict(a, {})` / notDeepStrictEqual of differing prototypes doesn't throw).
