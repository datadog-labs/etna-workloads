Patches classmethod/staticmethod `Foo.cm(cls, a, b)` / `Foo.sm(a, b)` with `mock.patch.object(..., autospec=True)`, then calls each with too few arguments.
Clean: raises `TypeError: missing a required argument: 'b'` for both.
Buggy: the signature is not unwrapped from the classmethod/staticmethod object, so the call is not checked and no error is raised ("no error").
