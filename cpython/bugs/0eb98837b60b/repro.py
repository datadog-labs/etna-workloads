import threading
for L in (threading.RLock, threading._PyRLock):
    lock = L()
    print(lock._recursion_count())
    lock.acquire(); lock.acquire()
    print(lock._recursion_count())
    res = []
    t = threading.Thread(target=lambda: res.append(lock._recursion_count()))
    t.start(); t.join()
    print(res)
