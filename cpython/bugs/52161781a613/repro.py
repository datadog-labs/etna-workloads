import asyncio

async def main():
    sem = asyncio.Semaphore(0)
    result = []
    t4 = None

    async def c1():
        await sem.acquire()
        print("c1 value after acquire:", sem._value)
        nonlocal t4
        t4 = asyncio.create_task(c4())
        result.append(1)

    async def c2():
        sem.release(); sem.release(); sem.release()
        await sem.acquire()
        result.append(2)

    async def c3():
        await sem.acquire()
        result.append(3)

    async def c4():
        result.append(4)

    t1 = asyncio.create_task(c1())
    t2 = asyncio.create_task(c2())
    t3 = asyncio.create_task(c3())
    await asyncio.sleep(0)
    await asyncio.sleep(0)
    await asyncio.gather(t1, t2, t3, t4)
    print(result)

asyncio.run(main())
