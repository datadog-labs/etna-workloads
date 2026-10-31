Builds `MyCallable[[int, str], bool]` for a Generic over a ParamSpec and prints its repr.
Clean: `...MyCallable[[int, str], bool]`; buggy: the parameter list is rendered as a tuple, `(<class 'int'>, <class 'str'>)`.
