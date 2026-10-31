from contextlib import contextmanager

@contextmanager
def cm():
    print("enter")
    try:
        yield
    finally:
        print("exit")

@cm()
def gen():
    print("body")
    yield 1
    yield 2

g = gen()
print("created")
print(list(g))
