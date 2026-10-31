import asyncio

async def main():
    try:
        await asyncio.wait_for(asyncio.sleep(float("nan")), 0.1)
    except ValueError as e:
        print("ValueError:", e)
    except TimeoutError:
        print("TimeoutError")

asyncio.run(main())
