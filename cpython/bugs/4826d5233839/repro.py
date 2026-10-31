import asyncio, asyncio.futures

class MyStop(StopIteration):
    pass

for name, cls in (("C", asyncio.Future), ("Py", asyncio.futures._PyFuture)):
    for exc in (StopIteration, MyStop):
        loop = asyncio.new_event_loop()
        f = cls(loop=loop)
        try:
            f.set_exception(exc())
            e = f.exception()
            print(name, exc.__name__, type(e).__name__, type(e.__cause__).__name__)
        except BaseException as x:
            print(name, exc.__name__, "raised", type(x).__name__)
        loop.close()
