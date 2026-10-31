async def agen():
    yield 1

class MyException(Exception):
    pass

nxt = agen().aclose()
try:
    nxt.throw(MyException)
except BaseException as e:
    print(type(e).__name__)
try:
    nxt.throw(MyException)
except BaseException as e:
    print(type(e).__name__, e)
