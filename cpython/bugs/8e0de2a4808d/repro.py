async def agen():
    yield 1

it = agen()
nxt = it.aclose()
try:
    nxt.throw(GeneratorExit)
except BaseException as e:
    print(type(e).__name__, e)
try:
    nxt.throw(GeneratorExit)
except BaseException as e:
    print(type(e).__name__, e)
