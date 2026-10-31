import asyncio, socket

class P(asyncio.Protocol):
    paused = False
    def pause_writing(self):
        self.paused = True

async def main():
    loop = asyncio.get_running_loop()
    a, b = socket.socketpair()
    tr, pr = await loop.create_connection(P, sock=a)
    tr.set_write_buffer_limits(high=1)
    tr.writelines([b'x' * 10_000_000])
    print(tr.get_write_buffer_size() > 1, pr.paused)
    tr.abort()
    b.close()

asyncio.run(main())
