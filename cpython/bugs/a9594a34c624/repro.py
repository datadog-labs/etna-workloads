src = 'class with_docstring:\n    "docstring"\n'
ns = {}
exec(compile(src, "<test>", "single"), ns)
print(repr(ns['with_docstring'].__doc__))

src = 'def f():\n    "d1"\n    return 1\n'
ns = {}
exec(compile(src, "<test>", "single"), ns)
print(repr(ns['f'].__doc__))
