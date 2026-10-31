import asyncio, socket

async def main():
    a, b = socket.socketpair()
    loop = asyncio.get_running_loop()
    tr, _ = await loop.create_connection(asyncio.Protocol, sock=a)
    tr.close()
    await asyncio.sleep(0)
    try:
        tr.write_eof()
        print("ok")
    except Exception as e:
        print(type(e).__name__)
    b.close()

asyncio.run(main())
