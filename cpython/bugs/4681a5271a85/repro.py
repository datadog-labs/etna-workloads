import asyncio

async def main():
    messages = []
    asyncio.get_running_loop().set_exception_handler(
        lambda loop, ctx: messages.append(ctx['message']))

    async def handle_echo(reader, writer):
        writer.close()
        asyncio.current_task().cancel()

    server = await asyncio.start_server(handle_echo, '127.0.0.1', 0)
    port = server.sockets[0].getsockname()[1]
    rd, wr = await asyncio.open_connection('127.0.0.1', port)
    data = await asyncio.wait_for(rd.read(), 10)
    print(repr(data))
    wr.close()
    await wr.wait_closed()
    server.close()
    await server.wait_closed()
    print(len(messages), [m.split(" at ")[0] for m in messages])

asyncio.run(main())
