class Silly:
    def __iter__(self):
        raise RuntimeError("nobody expects the spanish inquisition")

def my_generator():
    yield from Silly()

try:
    next(iter(my_generator()))
except RuntimeError as e:
    print("RuntimeError:", e)
