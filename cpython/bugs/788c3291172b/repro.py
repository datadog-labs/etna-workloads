import asyncio, socket

async def main():
    conn_event = asyncio.Event()
    class Proto(asyncio.Protocol):
        def connection_made(self, transport):
            conn_event.set()

    loop = asyncio.get_running_loop()
    srv = await loop.create_server(Proto, '127.0.0.1', 0)
    task = asyncio.create_task(srv.serve_forever())
    await asyncio.sleep(0)
    sock = socket.socket()
    sock.connect(srv.sockets[0].getsockname())
    await conn_event.wait()
    task.cancel()
    try:
        async with asyncio.timeout(0.5):
            await srv.wait_closed()
        print("closed")
    except TimeoutError:
        print("timeout")
    print(srv.is_serving())
    sock.close()

asyncio.run(main())
