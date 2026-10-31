# Rationale

Fix hunk reversed: the `Enum.__new__` check in Lib/enum.py ("still not found --
verify that members exist ... raise TypeError('... has no members defined')").
In v3.15.2 this block also carries an `__in_progress` variant of the message;
I removed the whole block, so `super().__new__(cls, value)` called from a custom
`__new__` during class creation falls through to `_missing_` instead of raising
TypeError (the pre-fix behaviour).

Not reverted: the `names = ()` hunk in `_create_` (only needed by the new
functional-API tests, not part of the bug mechanism); docs/tests untouched.

Oracle failure: `test_bad_new_super` (all Class/Function variants) fails with
"TypeError not raised"; other oracle cases also fail (22 errors, 2 failures).
