import asyncio, gc
from asyncio import futures
loop = asyncio.new_event_loop()
f = futures._PyFuture(loop=loop)
f.cancel()
exc = None
try:
    f.result()
except asyncio.CancelledError as e:
    exc = e
print(len(gc.get_referrers(exc)))
loop.close()
