import asyncio

async def crash():
    try:
        await asyncio.sleep(1)
    finally:
        1/0

async def main():
    try:
        async with asyncio.timeout(0.01):
            await crash()
    except ZeroDivisionError as e:
        print(repr(e.__cause__))
        e2 = e.__context__
        print(type(e2).__name__)
        print(type(getattr(e2, '__cause__', None)).__name__)

asyncio.run(main())
