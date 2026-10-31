import asyncio, gc
from asyncio import futures

loop = asyncio.new_event_loop()
for meth in ("result", "exception"):
    f = futures._PyFuture(loop=loop)
    f.cancel()
    exc = None
    try:
        getattr(f, meth)()
    except asyncio.CancelledError as e:
        exc = e
    print(meth, len(gc.get_referrers(exc)))
loop.close()
