import asyncio, socket
from unittest import mock

async def getaddrinfo(*a, **k):
    return [(socket.AF_INET, socket.SOCK_STREAM, 0, '', ('127.0.0.1', 80)),
            (socket.AF_INET6, socket.SOCK_STREAM, 0, '', ('::1', 80))]

async def mock_race(coro_fns, delay, loop):
    return None, []

async def main():
    loop = asyncio.get_running_loop()
    loop.getaddrinfo = getaddrinfo
    with mock.patch('asyncio.staggered.staggered_race', side_effect=mock_race):
        try:
            await loop.create_connection(asyncio.Protocol, 'example.com', 80,
                                         happy_eyeballs_delay=0.1)
        except BaseException as e:
            print(type(e).__name__, e)

asyncio.run(main())
