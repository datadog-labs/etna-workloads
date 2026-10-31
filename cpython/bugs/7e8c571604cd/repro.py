import asyncio

loop = asyncio.new_event_loop()
h = loop.call_soon_threadsafe(lambda: None)
print(type(h).__name__)
print(hasattr(h, '_lock'))
loop.close()
