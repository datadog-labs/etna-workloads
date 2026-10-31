import asyncio, threading, warnings

ev = threading.Event()

async def main():
    loop = asyncio.get_running_loop()
    loop.run_in_executor(None, ev.wait)
    threading.Timer(1.0, ev.set).start()
    with warnings.catch_warnings(record=True) as w:
        warnings.simplefilter("always")
        await loop.shutdown_default_executor(timeout=0.1)
    print([str(x.message) for x in w])
    print("event set before return:", ev.is_set())

asyncio.run(main())
