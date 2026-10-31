import asyncio

async def async_generator():
    yield object()

async def run():
    ag = async_generator()
    t = asyncio.create_task(ag.aclose())
    try:
        print(t.get_stack())
    except Exception as e:
        print(type(e).__name__, e)

asyncio.run(run())
