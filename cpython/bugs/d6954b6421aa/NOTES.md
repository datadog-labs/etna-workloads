Calls `FrameLocalsProxy(1)` (type obtained from a function frame's `f_locals`) with a non-frame argument.
Clean: `TypeError: expect frame, not int`. Buggy: the argument validation is gone, so the debug build aborts on `assert(PyFrame_Check(frame))` (exit -6); a release build would misuse the object as a frame.
