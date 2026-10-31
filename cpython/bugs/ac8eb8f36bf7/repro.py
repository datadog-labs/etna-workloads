import asyncio

async def main():
    loop = asyncio.get_running_loop()
    infos = await loop._ensure_resolved(('fe80::1', 80, 0, 1), loop=loop)
    print(repr(infos[0][4]))

asyncio.run(main())
