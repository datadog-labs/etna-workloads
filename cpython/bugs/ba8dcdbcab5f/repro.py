import asyncio, socket

async def main():
    loop = asyncio.get_running_loop()
    srv = await asyncio.start_server(lambda r, w: None, '127.0.0.1', 0)
    port = srv.sockets[0].getsockname()[1]
    orig = loop.getaddrinfo

    async def getaddrinfo(host, p, *args, **kwargs):
        if host == 'fake-local':
            return [(socket.AF_INET6, socket.SOCK_STREAM, 0, '', ('::1', 0, 0, 0))]
        return await orig(host, p, *args, **kwargs)

    loop.getaddrinfo = getaddrinfo
    try:
        await loop.create_connection(asyncio.Protocol, '127.0.0.1', port,
                                     local_addr=('fake-local', 0))
    except OSError as e:
        print(type(e).__name__, e)
    srv.close()

asyncio.run(main())
