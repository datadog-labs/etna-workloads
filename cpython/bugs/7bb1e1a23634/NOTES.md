Defines a `@warnings.deprecated` metaclass whose `__new__` takes a keyword `cls`, then uses it with `cls='haha'`.
Clean prints `cls = 'haha'`; buggy's generated `__new__(cls, *args, **kwargs)` shadows the user's `cls` kwarg, raising TypeError (multiple values for argument 'cls').
