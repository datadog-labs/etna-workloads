import asyncio
loop = asyncio.new_event_loop()
f = asyncio.Future(loop=loop)
try:
    f.__init__(loop=loop)
    print("no error")
except RuntimeError as e:
    print("RuntimeError", e)

async def foo():
    pass
coro = foo()
t = asyncio.Task(coro, loop=loop)
t._log_destroy_pending = False
try:
    t.__init__(coro, loop=loop)
    print("no error")
except RuntimeError as e:
    print("RuntimeError", e)
coro.close()
loop.close()
