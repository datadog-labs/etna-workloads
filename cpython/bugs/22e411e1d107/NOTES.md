Reproducer: defines a NamedTuple class whose body holds an object with `__set_name__`.
Clean: `__set_name__` is called (prints True) and a raising `__set_name__` propagates with an
"Error calling __set_name__" note. Buggy: `__set_name__` is never called (prints False, "no error").
