import asyncio, socket

async def main():
    loop = asyncio.get_running_loop()
    a, b = socket.socketpair()
    a.setblocking(False)
    t = asyncio.create_task(loop.sock_recv(a, 10))
    await asyncio.sleep(0)
    t.cancel()
    # new sock_recv registers its reader before the cancelled one's done callback runs
    loop.call_later(0.1, b.send, b'hello')
    try:
        print(repr(await asyncio.wait_for(loop.sock_recv(a, 10), 2)))
    except asyncio.TimeoutError:
        print('timeout: second sock_recv never completed')
    a.close(); b.close()

asyncio.run(main())
