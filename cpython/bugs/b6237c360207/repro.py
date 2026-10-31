async def gen():
    yield 1

g = gen()
try:
    g.athrow()
except TypeError as e:
    print("TypeError:", e)
else:
    print("no immediate error")
