Calls Future.set_exception(StopIteration()) / a StopIteration subclass on both the C and Python futures.
Fixed: stored exception becomes RuntimeError with __cause__ = the StopIteration.
Buggy: set_exception raises TypeError (or doesn't wrap subclasses), so the output differs.
