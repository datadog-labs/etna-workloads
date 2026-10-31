import asyncio
loop = asyncio.new_event_loop()
fut = loop.create_future()
f1 = lambda _: 1
f2 = lambda _: 2
fut.add_done_callback(f1)
fut.add_done_callback(f2)
print(fut._callbacks is fut._callbacks)
fut.remove_done_callback(f1)
print(fut._callbacks is fut._callbacks)
fut._callbacks.clear()
print(len(fut._callbacks))
loop.close()
