repro.py defines a dataclass with an undefined annotation name and prints its `__doc__`, then prints `inspect.formatannotation(ForwardRef('Foo'))`.

Clean: the docstring is built from a FORWARDREF-format signature, so the class is created and `formatannotation` prints `Foo`.
Buggy: the signature is taken without FORWARDREF format, so class creation raises NameError (exit status 1).
