import asyncio
from unittest import mock

loop = asyncio.new_event_loop()
sock = mock.Mock()

def accept():
    if sock.accept.call_count % 2 == 0:
        raise ConnectionAbortedError
    return (mock.Mock(), mock.Mock())

sock.accept.side_effect = accept
with mock.patch.object(loop, '_accept_connection2'):
    loop._accept_connection(mock.Mock(), sock, backlog=100)
loop.run_until_complete(asyncio.sleep(0))
print(sock.accept.call_count)
loop.close()
