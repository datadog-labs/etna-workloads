import types

@types.coroutine
def _async_yield(v):
    return (yield v)

async def agenfn():
    try:
        await _async_yield(None)
    except GeneratorExit:
        await _async_yield(None)
    return
    yield

gen = agenfn().asend(None)
gen.send(None)
try:
    print(repr(gen.close()))
except RuntimeError as e:
    print("RuntimeError:", e)
