import asyncio

class Conn:
    def setblocking(self, flag): pass

class Sock:
    def __init__(self):
        self.calls = 0
    def accept(self):
        self.calls += 1
        return Conn(), ('addr',)

loop = asyncio.new_event_loop()
loop._accept_connection2 = lambda *a, **k: asyncio.sleep(0)
for backlog in [0, 1, 5]:
    sock = Sock()
    loop._accept_connection(lambda *a: None, sock, backlog=backlog)
    loop.run_until_complete(asyncio.sleep(0))
    print(backlog, sock.calls)
loop.close()
