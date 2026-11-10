# Bug
Loose `assert.deepEqual` started comparing enumerable symbol properties of arrays and
typed arrays/boxed values (it should ignore symbols in loose mode; only strict compares them).

# Change (lib/internal/util/comparisons.js)
The fix added `SKIP_SYMBOLS` to the filter for loose mode in two places (array branch and
typed-array/boxed-primitive branch). In today's code these are the two
`const filter = mode !== kLoose ? ONLY_ENUMERABLE : ONLY_ENUMERABLE | SKIP_SYMBOLS;` lines.
Both are reverted to `const filter = ONLY_ENUMERABLE;`, so symbols are counted in loose mode
too (pre-fix behaviour). The now-unused `SKIP_SYMBOLS` import was removed (corresponds to the
import hunk).

# Failing test
parallel/test-assert-deep: "not ok" — AssertionError [ERR_ASSERTION]: Expected values to be
loosely deep-equal (operator 'deepEqual'), e.g. typed arrays / arrays differing only in a symbol property.
Failure was observed on repeated runs.
