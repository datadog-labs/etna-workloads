import asyncio, socket

class P(asyncio.Protocol):
    def __init__(self):
        self.done = asyncio.Future()
        self.again = True
    def resume_writing(self):
        if self.again:
            self.again = False
            self.transport.write(b"B" * 100000)
    def connection_made(self, t):
        self.transport = t
    def connection_lost(self, exc):
        self.done.set_result(exc)

async def main():
    loop = asyncio.get_running_loop()
    a, b = socket.socketpair()
    a.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 4096)
    b.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 4096)
    b.setblocking(False)
    tr, p = await loop.create_connection(P, sock=a)
    tr.set_write_buffer_limits(high=1)
    tr.write(b"A" * 1000000)
    print("paused", p.transport.get_write_buffer_size() > 0)
    tr.close()
    total = 0
    while True:
        try:
            d = b.recv(65536)
        except BlockingIOError:
            await asyncio.sleep(0.01)
            continue
        if not d:
            break
        total += len(d)
    print("received", total)
    print("lost", repr(await p.done))
    b.close()

try:
    asyncio.run(asyncio.wait_for(main(), 5))
except TimeoutError:
    print("timeout")
