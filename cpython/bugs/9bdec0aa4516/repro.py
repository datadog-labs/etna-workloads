import asyncio

async def main():
    loop = asyncio.get_running_loop()
    transport, _ = await loop.create_datagram_endpoint(
        asyncio.DatagramProtocol, local_addr=('127.0.0.1', 0))
    print(isinstance(transport, asyncio.DatagramTransport))
    transport.close()

asyncio.run(main())
