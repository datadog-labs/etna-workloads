import asyncio, gc, socket, warnings

async def main():
    fut = asyncio.get_running_loop().create_future()

    async def inner(rd, wr):
        with warnings.catch_warnings(record=True) as w:
            warnings.simplefilter("always")
            del wr
            gc.collect()
        fut.set_result([str(x.message)[:18] for x in w])

    srv = await asyncio.start_server(inner, "127.0.0.1", 0)
    addr = srv.sockets[0].getsockname()
    with socket.create_connection(addr):
        print(await fut)
    srv.close()

asyncio.run(main())
