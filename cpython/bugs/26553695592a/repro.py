import asyncio

async def main():
    srv = await asyncio.start_server(lambda r, w: None, '127.0.0.1', 0)
    t = asyncio.ensure_future(srv.wait_closed())
    await asyncio.sleep(0.05)
    print('wait_closed done while server open:', t.done())
    srv.close()
    await t
    print('finished')

asyncio.run(main())
