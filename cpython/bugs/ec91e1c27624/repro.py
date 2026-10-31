import asyncio
from asyncio.staggered import staggered_race

async def main():
    log = []
    try:
        async with asyncio.timeout(None) as outer, asyncio.timeout(None) as inner:
            async def coro_fn():
                inner.reschedule(-1)
                await asyncio.sleep(0)
                try:
                    await asyncio.sleep(0)
                except asyncio.CancelledError:
                    log.append("cancelled 1")
                outer.reschedule(-1)
                await asyncio.sleep(0)
                try:
                    await asyncio.sleep(0)
                except asyncio.CancelledError:
                    log.append("cancelled 2")
            try:
                await staggered_race([coro_fn], delay=None)
            except asyncio.CancelledError:
                log.append("cancelled 3")
                raise
    except TimeoutError:
        print("TimeoutError")
    print(log)

asyncio.run(main())
