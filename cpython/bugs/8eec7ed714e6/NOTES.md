Instantiates a subclass of `typing.Any` with a custom `__init__` and arguments.
Clean: prints `ok`. Buggy: `Any.__new__` forwards args to `object.__new__`, raising TypeError.
