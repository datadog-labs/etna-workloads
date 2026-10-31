import builtins
import sys

d = builtins.__dict__
orig_iter = iter


class CustomStr:
    def __init__(self, name, iterator):
        self.name = name
        self.iterator = iterator

    def __hash__(self):
        return hash(self.name)

    def __eq__(self, other):
        list(self.iterator)  # exhaust the iterator during the builtins lookup
        return other == self.name


class EmptyIterClass:
    def __len__(self):
        return 0

    def __getitem__(self, i):
        raise StopIteration


def run(item, sentinel=None):
    it = orig_iter(item) if sentinel is None else orig_iter(item, sentinel)
    del d["iter"]
    d[CustomStr("iter", it)] = orig_iter
    try:
        return it.__reduce__()
    finally:
        for k in [k for k in d if isinstance(k, CustomStr)]:
            del d[k]
        d["iter"] = orig_iter


for case in [("xyz",), (EmptyIterClass(),), (bytes(8),), (bytearray(8),),
             (lambda: 0, 0)]:
    try:
        print(repr(run(*case)))
    except BaseException as e:
        print(type(e).__name__, e)
