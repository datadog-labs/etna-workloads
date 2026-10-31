import asyncio, socket

class Sock:
    def __init__(self, s):
        self.s = s
        self.block = True
    def sendto(self, data, addr):
        if self.block:
            raise BlockingIOError
        return self.s.sendto(data, addr)
    def __getattr__(self, n):
        return getattr(self.s, n)

async def main():
    loop = asyncio.get_running_loop()
    rx = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    rx.bind(('127.0.0.1', 0))
    addr = rx.getsockname()
    tr, _ = await loop.create_datagram_endpoint(
        asyncio.DatagramProtocol, family=socket.AF_INET)
    fake = Sock(tr._sock)
    tr._sock = fake
    tr.sendto(b'data', addr)
    print('queued', tr.get_write_buffer_size())
    await asyncio.sleep(0.05)   # writer retries, still blocked
    print('blocked', tr.get_write_buffer_size())
    fake.block = False
    await asyncio.sleep(0.05)
    print('sent', tr.get_write_buffer_size())
    tr.close()
    rx.close()

asyncio.run(main())
