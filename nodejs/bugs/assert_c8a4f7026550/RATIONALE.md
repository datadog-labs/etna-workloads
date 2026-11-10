# Bug
assert.deepStrictEqual/deepEqual treated Errors as equal when their `cause` or `errors` (AggregateError) differed, and ignored whether `message`/`name` were enumerable. Only `message` and `name` values were compared.

# Change (lib/internal/util/comparisons.js, Error branch of innerDeepEqual)
Single hunk, corresponding to the fix's single implementation hunk: replaced the `isEnumerableOrIdentical(... 'message'|'name'|'cause'|'errors')` checks and the follow-up `hasOwn(cause)` check (today's re-expression of the fix's enumerable/cause/errors checks) with the pre-fix check: `!isError(val2) || val1.message !== val2.message || val1.name !== val2.name`.

# Failing
parallel/test-assert-deep: "not ok" (stable over repeated runs); the new cause/AggregateError tests expect AssertionError from assert.throws on unequal errors, but nothing is thrown (operator: 'throws').
