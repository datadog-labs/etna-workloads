import asyncio

async def main():
    cm = asyncio.timeout(10)
    async with cm:
        try:
            async with cm:
                pass
        except RuntimeError as e:
            print("RuntimeError:", e)
    print("done")

asyncio.run(main())
