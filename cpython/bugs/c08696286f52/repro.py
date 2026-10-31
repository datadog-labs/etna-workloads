import asyncio

async def coro():
    pass

async def run():
    task = asyncio.get_running_loop().create_task(coro())
    await task
    print(repr(task.get_coro()))

loop = asyncio.new_event_loop()
loop.set_task_factory(asyncio.eager_task_factory)
loop.run_until_complete(run())
loop.close()
