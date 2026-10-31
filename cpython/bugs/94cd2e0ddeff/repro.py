import asyncio, gc

class Subclass(asyncio.Task):
    def __del__(self):
        pass

async def corofn():
    await asyncio.sleep(0.01)

loop = asyncio.new_event_loop()
coro = corofn()
task = Subclass(coro, loop=loop)
task._log_destroy_pending = False
del task
gc.collect()
coro.close()
print("ok")
loop.close()
