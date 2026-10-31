import asyncio, contextvars

cvar1 = contextvars.ContextVar("cvar1")
cvar2 = contextvars.ContextVar("cvar2")
cvar3 = contextvars.ContextVar("cvar3")
results = {}

def capture(meth):
    results[meth] = sorted((k.name, v) for k, v in contextvars.copy_context().items()
                           if k.name.startswith("cvar"))

class Proto(asyncio.Protocol):
    def __init__(self, lost):
        self.lost = lost
        self.tasks = set()
    def connection_made(self, transport):
        capture("connection_made")
        self.transport = transport
    def data_received(self, data):
        capture("data_received")
        t = asyncio.create_task(self.asgi())
        self.tasks.add(t)
        t.add_done_callback(self.tasks.discard)
        self.transport.pause_reading()
    def connection_lost(self, exc):
        capture("connection_lost")
        if not self.lost.done():
            self.lost.set_result(True)
    async def asgi(self):
        capture("asgi start")
        cvar1.set(True)
        while not self.transport._paused:
            await asyncio.sleep(0.01)
        cvar2.set(True)
        self.transport.resume_reading()
        cvar3.set(True)
        capture("asgi end")

async def main():
    loop = asyncio.get_running_loop()
    lost = loop.create_future()
    server = await loop.create_server(lambda: Proto(lost), '127.0.0.1', 0)
    async with server:
        addr = server.sockets[0].getsockname()
        r, w = await asyncio.open_connection(*addr)
        w.write(b"anything")
        await w.drain()
        w.close()
        await w.wait_closed()
        await lost

asyncio.run(main())
for k in sorted(results):
    print(k, results[k])
