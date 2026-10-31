import asyncio, gc, threading

status = {'finalized': False}

async def main():
    asyncio.get_running_loop().set_debug(True)
    gc.disable()

    async def leave():
        class Box: pass
        b = Box()
        async def g():
            me = b  # frame -> b -> generator: a reference cycle
            yield 1
        b.g = a = g()
        await a.__anext__()
        # cycle holds a finalizer-pending generator; gc will run it

    async def g_final():
        pass

    await leave()
    t = threading.Thread(target=gc.collect)  # finalizer hook runs in another thread
    t.start(); t.join()
    for _ in range(5):
        await asyncio.sleep(0)

asyncio.run(main())
print("done")
