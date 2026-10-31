import asyncio
from test.test_asyncio import utils as test_utils

async def handler(reader, writer):
    await reader._wait_for_data('x')  # ClientHello now buffered in the reader
    await writer.start_tls(test_utils.simple_server_sslcontext())
    print('server got', await reader.readline())
    writer.write(b"pong\n")
    await writer.drain()
    writer.close()

async def main():
    server = await asyncio.start_server(handler, '127.0.0.1', 0)
    reader, writer = await asyncio.open_connection(*server.sockets[0].getsockname())
    await writer.start_tls(test_utils.simple_client_sslcontext())
    writer.write(b"ping\n")
    print('client got', await reader.readline())
    writer.close()
    server.close()

try:
    asyncio.run(asyncio.wait_for(main(), 3))
except BaseException as e:
    print(type(e).__name__)
