Defines a `@warnings.deprecated` class A (no own `__init_subclass__`) and a sibling base B whose
`__init_subclass__` takes `x`. Creates `class C(A, B, x=42)`.
Clean: prints 42 for both base orders. Buggy: with (A, B) the wrapper forwards to
object's `__init_subclass__` instead of B's, raising `TypeError: A.__init_subclass__() takes no keyword arguments`.
