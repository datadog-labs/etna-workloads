Reproducer: reads `sys._getframe().f_locals["a"]` inside a list comprehension at module level, in a function and in a class body.
Clean: prints False, 0, 0, 0. Buggy: the second line raises KeyError: 'a', because the comprehension iteration variable is missing from frame.f_locals (frame_getlocals bypasses _PyFrame_GetLocals).
