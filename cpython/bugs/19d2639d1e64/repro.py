import asyncio, socket

async def main():
    loop = asyncio.get_running_loop()
    a, b = socket.socketpair()
    a.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 4096)
    b.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4096)
    transport, _ = await loop.create_connection(asyncio.Protocol, sock=a)
    total = 4 * 1024 * 1024
    transport.writelines([b'x' * total])
    print('buffered after writelines:', transport.get_write_buffer_size() > 0)
    b.setblocking(False)
    got = 0
    try:
        async with asyncio.timeout(3):
            while got < total:
                data = await loop.sock_recv(b, 65536)
                if not data:
                    break
                got += len(data)
    except TimeoutError:
        print('timeout')
    print('received all:', got == total)
    transport.abort()
    b.close()

asyncio.run(main())
