repro.py execs a class body containing `[super for x in [1]]` and `[__class__ for x in [1]]`.
Clean: prints `[<class 'super'>]` and `NameError name '__class__' is not defined`.
Buggy: both raise SystemError from _PyST_GetScope (inlined comprehension in class scope mishandles __class__/super).
