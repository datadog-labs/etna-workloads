async def foo():
    if False:
        yield (1, 2)

async def run():
    it = foo().__aiter__()
    try:
        await it.__anext__()
    except StopAsyncIteration:
        print("StopAsyncIteration")
    return await anext(it, ('a', 'b'))

c = run()
try:
    c.send(None)
except StopIteration as e:
    print(repr(e.value))
