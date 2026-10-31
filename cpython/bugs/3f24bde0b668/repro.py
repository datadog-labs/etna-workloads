import asyncio, ssl
from asyncio import sslproto
from unittest import mock

loop = asyncio.new_event_loop()
asyncio.set_event_loop(loop)

sock = mock.Mock()
sock.fileno = mock.Mock(return_value=12345)
sock.send = mock.Mock(side_effect=BrokenPipeError)

reader = asyncio.StreamReader(limit=2 ** 16, loop=loop)
protocol = asyncio.StreamReaderProtocol(reader, loop=loop)
ssl_proto = sslproto.SSLProtocol(loop, protocol, mock.Mock(), None,
                                 ssl_handshake_timeout=0.1)

sslobj = mock.Mock()
sslobj.read.side_effect = ssl.SSLWantReadError
sslobj.write.side_effect = ssl.SSLWantReadError
ssl_proto._sslobj = sslobj

data = b'An interesting message'
outgoing = mock.Mock()
outgoing.read = mock.Mock(return_value=data)
outgoing.pending = len(data)
ssl_proto._outgoing = outgoing

loop._make_socket_transport(sock, ssl_proto)
transport = ssl_proto._app_transport
writer = asyncio.StreamWriter(transport, protocol, reader, loop)

async def write():
    writer.write(data)
    await writer.drain()

async def main():
    await write()
    try:
        await asyncio.wait_for(write(), 2)
    except BaseException as e:
        print(type(e).__name__)
    else:
        print("no exception")

loop.run_until_complete(main())
