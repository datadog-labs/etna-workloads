import asyncio, socket

class P(asyncio.Protocol):
    def connection_made(self, tr):
        self.tr = tr
        tr.pause_reading()
    def data_received(self, data):
        print("data_received", data)

async def main():
    loop = asyncio.get_running_loop()
    a, b = socket.socketpair()
    b.send(b"x")
    tr, p = await loop.create_connection(P, sock=a)
    await asyncio.sleep(0.05)
    print("is_reading", tr.is_reading())
    tr.close()
    b.close()

asyncio.run(main())
