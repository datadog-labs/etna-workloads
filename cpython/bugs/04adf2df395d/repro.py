import asyncio

async def main():
    try:
        asyncio.current_task().cancel()
        await asyncio.sleep(1)
    except asyncio.CancelledError:
        pass
    finally:
        try:
            async with asyncio.timeout(0.0):
                await asyncio.sleep(1)
        except BaseException as e:
            print(type(e).__name__)

asyncio.run(main())
