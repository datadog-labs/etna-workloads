class CallGeneratorOnDealloc:
    def __del__(self):
        next(x for x in [1])

async def coro():
    obj = CallGeneratorOnDealloc()
    return 42

c = coro()
try:
    c.send(None)
except StopIteration as e:
    print("result", repr(e.value))
