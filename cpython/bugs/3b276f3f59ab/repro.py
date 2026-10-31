import signal, threading, time, _testlimitedcapi

started = threading.Event()
caught = None

class Injected(Exception):
    pass

def work():
    global caught
    try:
        started.set()
        time.sleep(86400)
    except Injected as e:
        caught = e

t = threading.Thread(target=work, daemon=True)
t.start()
started.wait()
signal.signal(signal.SIGUSR1, lambda s, f: None)
print(_testlimitedcapi.threadstate_set_async_exc(t.ident, Injected))
deadline = time.monotonic() + 3
while t.is_alive() and time.monotonic() < deadline:
    signal.pthread_kill(t.ident, signal.SIGUSR1)
    time.sleep(0.01)
t.join(0.1)
print(t.is_alive(), type(caught).__name__)
