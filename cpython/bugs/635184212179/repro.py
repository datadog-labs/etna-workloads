import threading
from concurrent import futures
from concurrent.futures.process import BrokenProcessPool
from operator import mul

orig = threading._start_joinable_thread
n = 0
def mock(func, *args, **kw):
    global n
    if n >= 1:
        raise RuntimeError("can't create new thread at interpreter shutdown")
    n += 1
    return orig(func, *args, **kw)

if __name__ == "__main__":
    threading._start_joinable_thread = mock
    executor = futures.ProcessPoolExecutor(max_workers=2)
    try:
        with executor:
            list(executor.map(mul, [2, 3] * 10, [2, 3] * 10))
    except BrokenProcessPool as e:
        print("BrokenProcessPool")
    executor.shutdown()
