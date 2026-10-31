import threading
import time

thread_started_event = threading.Event()
lock = threading.Lock()

def loop():
    with lock:
        thread_started_event.set()
        while True:
            time.sleep(1)

class Cycle:
    def __init__(self):
        self.self_ref = self
        self.thr = threading.Thread(target=loop, daemon=True)
        self.thr.start()
        thread_started_event.wait()

    def __del__(self):
        try:
            lock.acquire()
        except PythonFinalizationError:
            print('got the correct exception!')

Cycle()
