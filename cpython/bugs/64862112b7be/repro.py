import functools

class BadStr(str):
    def __eq__(self, other):
        raise RuntimeError("boom")
    def __hash__(self):
        return str.__hash__(self)

def f(**kwargs):
    return kwargs

p = functools.partial(f, poison="")
try:
    print(repr(p(**{BadStr("poison"): "new_value"})))
except RuntimeError as e:
    print("RuntimeError", e)
