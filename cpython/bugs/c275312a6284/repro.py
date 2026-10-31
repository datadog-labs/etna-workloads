async def gen():
    yield 1

async def main():
    g = gen()
    await g.__anext__()
    await g.aclose()
    print("closed")

try:
    main().send(None)
except BaseException as e:
    print(type(e).__name__, e)
