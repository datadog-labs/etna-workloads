import asyncio

async def coro():
    pass

async def main():
    tg = asyncio.TaskGroup()
    c = coro()
    try:
        tg.create_task(c)
    except RuntimeError as e:
        print("RuntimeError: not entered")
    print(c.cr_frame is None)

asyncio.run(main())
