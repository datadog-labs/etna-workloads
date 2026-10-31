import os
import sys
import threading
import time
import _testcapi

lock = threading.Lock()
lock.acquire()
started = threading.Event()

def thread_func():
    try:
        started.set()
        _testcapi.finalize_thread_hang(lock.acquire)
    finally:
        os._exit(2)

t = threading.Thread(target=thread_func, daemon=True)
t.start()
started.wait()
time.sleep(0.1)

def run_during_finalization():
    lock.release()
    time.sleep(0.1)
    os._exit(0)

orig_flush = sys.stderr.flush
def do_flush(*args, **kwargs):
    orig_flush(*args, **kwargs)
    if not sys.is_finalizing():
        return
    sys.stderr.flush = orig_flush
    run_during_finalization()

sys.stderr.flush = do_flush
sys.exit(1)
