import types, inspect

def gen():
    yield 1
    yield 2

@types.coroutine
def coro():
    return gen()

g = coro()
print(type(g).__name__)
for step in range(2):
    for f in (inspect.getgeneratorstate, inspect.getcoroutinestate):
        try:
            print(f.__name__, f(g))
        except Exception as e:
            print(f.__name__, type(e).__name__, e)
    next(g)
g.close()
