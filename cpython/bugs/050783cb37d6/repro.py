import signal, functools

class Arg:
    def __init__(self):
        self.repr_count = 0
    def __repr__(self):
        self.repr_count += 1
        return super().__repr__()

arg = Arg()
handler = functools.partial(lambda a, s, f: None, arg)
old = signal.signal(signal.SIGHUP, handler)
signal.signal(signal.SIGHUP, old)
print(arg.repr_count)
