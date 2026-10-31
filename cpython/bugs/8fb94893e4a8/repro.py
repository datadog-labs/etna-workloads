import asyncio, socket

calls = []
def fake_gai(host, port, family=0, type=0, proto=0, flags=0):
    calls.append((host, port, family, type, proto, flags))
    return [(family, type, proto, '', ('127.0.0.1', 9))]
socket.getaddrinfo = fake_gai

async def main():
    loop = asyncio.get_running_loop()
    for t in (socket.SOCK_STREAM, socket.SOCK_DGRAM):
        s = socket.socket(socket.AF_INET, t)
        s.setblocking(False)
        try:
            await loop.sock_connect(s, ('need-resolution.com', 8080))
        except OSError:
            pass
        s.close()
        print(calls[-1])

asyncio.run(main(), loop_factory=asyncio.SelectorEventLoop)
