import asyncio

drained = 0

async def drainer(stream):
    global drained
    await stream._drain_helper()
    drained += 1

async def main():
    loop = asyncio.get_running_loop()
    stream = asyncio.streams.FlowControlMixin(loop)
    stream.pause_writing()
    loop.call_later(0.1, stream.resume_writing)
    await asyncio.gather(*[drainer(stream) for _ in range(10)])
    print(drained)

asyncio.run(main())
