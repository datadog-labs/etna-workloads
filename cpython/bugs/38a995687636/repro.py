import asyncio

async def coro():
    print(asyncio.current_task().get_name())

async def main():
    t = asyncio.get_running_loop().create_task(coro(), name="test name")
    await t

loop = asyncio.new_event_loop()
loop.set_task_factory(asyncio.eager_task_factory)
loop.run_until_complete(main())
loop.close()
