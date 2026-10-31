import asyncio

async def main():
    try:
        async with asyncio.timeout(0) as cm:
            await asyncio.sleep(0)
    except TimeoutError:
        print("TimeoutError")
    print(cm.expired())

asyncio.run(main())
