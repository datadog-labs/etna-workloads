import asyncio, os, socket

async def main():
    path = os.path.join(os.getcwd(), 's.sock')
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
    sock.bind(path)
    sock.close()
    loop = asyncio.get_running_loop()
    try:
        transport, _ = await loop.create_datagram_endpoint(
            asyncio.DatagramProtocol, path, family=socket.AF_UNIX)
        transport.close()
        print('bound over existing socket file')
    except OSError as e:
        print('error:', type(e).__name__, e.strerror)
    os.path.exists(path) and os.remove(path)

asyncio.run(main())
