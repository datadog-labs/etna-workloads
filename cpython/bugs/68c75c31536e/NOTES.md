`repro.py` calls `super(MyType, type(mytype)).__setattr__(mytype, "bar", 1)` in a loop, where `MyType` is a metaclass. This is the body of `test_unusual_getattro`.

Clean: prints `1`.
Buggy: the second `super()` argument is a class whose `tp_getattro` is not `PyObject_GenericGetAttr`. The injection passes `method_found_ptr` anyway, so the method is treated as unbound. The call fails with `TypeError: __setattr__ expected 2 arguments, got 3`.
