Creates a property (and a property subclass) whose getter object raises AttributeError for `__doc__`.
Clean: both print `None`. Buggy: the plain property gives `None`, but the subclass keeps its class docstring, so it prints 'A subclass of property'.
