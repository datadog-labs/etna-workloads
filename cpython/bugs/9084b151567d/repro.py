import asyncio
from unittest import mock

class CustomError(Exception):
    pass

async def getaddrinfo(*a, **k):
    return [(2, 1, 6, '', ('107.6.106.82', 80))]

loop = asyncio.new_event_loop()
loop.getaddrinfo = lambda *a, **k: loop.create_task(getaddrinfo())
loop.sock_connect = mock.Mock(side_effect=CustomError)
sock = mock.Mock()
sock.close.side_effect = OSError
with mock.patch('asyncio.base_events.socket.socket', return_value=sock):
    for kw in ({}, {'all_errors': True}):
        try:
            loop.run_until_complete(
                loop.create_connection(asyncio.Protocol, 'example.com', 80, **kw))
        except BaseException as e:
            print(type(e).__name__)
loop.close()
