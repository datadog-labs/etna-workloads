import functools, gc

g = None

class Function:
    def __call__(self):
        pass
    def __repr__(self):
        return "Function"

class Evil:
    triggered = False
    def __repr__(self):
        if not self.triggered and g is not None:
            self.triggered = True
            g.__setstate__((Function(), (None,), {"keyword": None}, None))
            gc.collect()
        return "Evil"

trigger = Evil()
g = functools.partial(Function(), trigger, None, k=None)
print(repr(g))
