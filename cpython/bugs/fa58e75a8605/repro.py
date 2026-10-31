import asyncio

async def coro():
    await fut
    return 42

loop = asyncio.new_event_loop()
fut = asyncio.Future(loop=loop)
task = loop.create_task(coro())
loop.run_until_complete(asyncio.sleep(0))
fut.set_result(None)
task.cancel()
task.uncancel()
print(task.cancelling())
try:
    print(loop.run_until_complete(task))
except asyncio.CancelledError:
    print("cancelled")
loop.close()
