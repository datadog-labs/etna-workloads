Defines a runtime-checkable Protocol with `__match_args__` plus x/y members and
isinstance-checks an object lacking `__match_args__`. Clean: True. Buggy:
`__match_args__` is no longer excluded from protocol attributes, so it is
required and the check returns False.
