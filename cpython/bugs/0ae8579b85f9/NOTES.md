repro.py execs a class body with two sibling comprehensions, `[super for _ in [1]]` and `[__class__ for _ in [1]]`.
Clean: prints `NameError name '__class__' is not defined`.
Buggy: the compiler aborts with `assemble.c: compute_localsplus_info: Assertion 'offset > cellvar_offset' failed`.
The cause is the inlined comprehension handling of `__class__` in symtable.c `inline_comprehension`.
