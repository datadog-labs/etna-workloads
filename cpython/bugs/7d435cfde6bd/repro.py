import asyncio, socket

async def main():
    loop = asyncio.get_running_loop()
    a, b = socket.socketpair()
    a.setblocking(False)
    tr = loop._make_socket_transport(a, asyncio.Protocol())
    tr.abort()  # connection lost
    tr.writelines([b'data'])
    print(tr.get_write_buffer_size())
    await asyncio.sleep(0)
    tr.writelines([b'data'])
    print(tr.get_write_buffer_size())
    b.close()

asyncio.run(main())
