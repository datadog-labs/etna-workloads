Builds a tracemalloc.Traceback with two frames and prints its repr.
Clean: `<Traceback (<Frame ...>, <Frame ...>) total_nframe=2>`.
Buggy: `"%r" % tuple(self)` treats the frames as multiple format args, so repr raises TypeError (not all arguments converted).
