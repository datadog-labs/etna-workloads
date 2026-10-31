import asyncio, sys

async def main():
    p = await asyncio.create_subprocess_exec(
        sys.executable, '-c', 'import sys; print(len(sys.stdin.buffer.read()))',
        stdin=asyncio.subprocess.PIPE, stdout=asyncio.subprocess.PIPE)
    try:
        out, _ = await asyncio.wait_for(p.communicate(None), 5)
        print(repr(out), p.returncode)
    except asyncio.TimeoutError:
        print("timeout: child never saw EOF on stdin")
        p.kill()
        await p.wait()

asyncio.run(main())
