import asyncio

async def main():
    condition = asyncio.Condition()
    state = 0
    async def consumer():
        nonlocal state
        async with condition:
            while True:
                await condition.wait_for(lambda: state != 0)
                if state < 0:
                    return
                state -= 1

    c = [asyncio.create_task(consumer()) for _ in range(2)]
    await asyncio.sleep(0)
    async with condition:
        state += 1
        condition.notify(1)
        c[0].cancel()
        try:
            async with asyncio.timeout(0.01):
                await condition.wait_for(lambda: state == 0)
        except TimeoutError:
            pass
        print("state", state)
        state = -1
        condition.notify_all()
    await c[1]

asyncio.run(main())
