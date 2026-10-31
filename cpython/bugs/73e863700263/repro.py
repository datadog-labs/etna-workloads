import asyncio, socket

async def main():
    loop = asyncio.get_running_loop()
    rx = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    rx.bind(('127.0.0.1', 0))
    rx.settimeout(1)
    tr, _ = await loop.create_datagram_endpoint(
        asyncio.DatagramProtocol, family=socket.AF_INET)
    tr.sendto(b'', rx.getsockname())
    try:
        print(repr(rx.recvfrom(10)[0]))
    except socket.timeout:
        print('nothing received')
    tr.close()
    rx.close()

asyncio.run(main())
