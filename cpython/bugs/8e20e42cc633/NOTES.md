repro.py: a generator yields its own frame (sys._getframe()), is closed while suspended
(fast path in gen_close), then deleted; the frame object outlives the generator and its
f_locals and f_back are read.
Clean: prints {'x': [1]} and None, exit 0.
Buggy: gen_close only calls _PyFrame_ClearLocals instead of gen_clear_frame, so the
frame object is not detached from the generator. Reading f_locals segfaults (exit -11).
