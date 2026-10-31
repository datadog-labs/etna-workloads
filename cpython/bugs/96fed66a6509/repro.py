from contextlib import contextmanager

@contextmanager
def whoo():
    try:
        yield
        yield
    finally:
        print("generator finalized")

ctx = whoo()
ctx.__enter__()
try:
    ctx.__exit__(None, None, None)
except RuntimeError as e:
    print("RuntimeError:", e)
print("after exit, suspended:", ctx.gen.gi_suspended)
