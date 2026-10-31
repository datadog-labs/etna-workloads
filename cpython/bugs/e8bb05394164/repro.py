import sys

def names(frame):
    out = []
    while frame:
        out.append(frame.f_code.co_name)
        frame = frame.f_back
    return out

class CustomGen:
    def throw(self, *args):
        print(names(sys._getframe())[:3])
    def __iter__(self):
        return self
    def __next__(self):
        return 42

def g(target):
    yield from target

gen = g(CustomGen())
gen.send(None)
gen.throw(RuntimeError)
