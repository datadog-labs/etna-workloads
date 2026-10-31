import _thread

class Loop(_thread._local):
    attr = 1

class NameCompareTrue:
    def __eq__(self, other):
        return True

loop = Loop()
try:
    loop.__setattr__(NameCompareTrue(), 2)
except BaseException as e:
    print(type(e).__name__, str(e).split(" at 0x")[0][:40])
