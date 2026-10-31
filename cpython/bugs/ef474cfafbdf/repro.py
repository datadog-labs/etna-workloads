import asyncio, sys
from unittest import mock

async def main():
    loop = asyncio.get_running_loop()
    loop.connect_read_pipe = mock.AsyncMock(side_effect=asyncio.CancelledError)
    try:
        await asyncio.create_subprocess_exec(
            sys.executable, '-c', 'import time; time.sleep(3600)',
            stderr=asyncio.subprocess.PIPE)
    except asyncio.CancelledError:
        print('cancelled')

asyncio.run(main())
print('done')
