class A:
    async def __anext__(self):
        raise StopAsyncIteration
    def __aiter__(self):
        return self

aw = anext(A(), "a").__await__()
try:
    aw.close(1)
except TypeError:
    print("TypeError")
else:
    print("no error")
