import traceback
from contextlib import contextmanager

@contextmanager
def f():
    yield

class StopIterationSubclass(StopIteration):
    pass

for stop_exc in (StopIteration('spam'), StopIterationSubclass('spam')):
    try:
        with f():
            raise stop_exc
    except type(stop_exc) as e:
        print([(fr.name, fr.line) for fr in traceback.extract_tb(e.__traceback__)])
