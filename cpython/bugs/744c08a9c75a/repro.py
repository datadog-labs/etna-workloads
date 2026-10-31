import asyncio, sys, pathlib

async def main():
    p = await asyncio.create_subprocess_exec(pathlib.Path(sys.executable), '-c', 'pass')
    print(await p.wait())
    p = await asyncio.create_subprocess_exec(sys.executable, '-c', 'pass', pathlib.Path('.'))
    print(await p.wait())

asyncio.run(main())
