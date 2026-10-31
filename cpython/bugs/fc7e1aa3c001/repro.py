import types

@types.coroutine
def _async_yield(v):
    return (yield v)

class MyExc(Exception):
    pass

async def agenfn():
    while True:
        try:
            await _async_yield(None)
        except MyExc:
            pass
    return
    yield

agen = agenfn()
gen = agen.asend(None)
gen.send(None)
gen2 = agen.asend(None)
try:
    gen2.throw(MyExc)
except BaseException as e:
    print(type(e).__name__, e)
try:
    gen2.send(None)
except BaseException as e:
    print(type(e).__name__, e)
