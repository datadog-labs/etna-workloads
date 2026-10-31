import asyncio

loop = asyncio.new_event_loop()
task = None

def factory(loop, coro):
    global task
    task = asyncio.Task(coro, loop=loop)
    return task

async def target():
    loop.set_task_factory(factory)
    fut = asyncio.run_coroutine_threadsafe(asyncio.sleep(10), loop)
    await asyncio.sleep(0)
    fut.cancel()
    return fut

fut = loop.run_until_complete(target())
print(task.cancelled(), fut.cancelled())
loop.close()
