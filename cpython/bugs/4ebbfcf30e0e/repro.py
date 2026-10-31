import threading

def loop():
    while True:
        pass

class Cycle:
    def __init__(self):
        self.self_ref = self
        self.thr = threading.Thread(target=loop, daemon=True)
        self.thr.start()

    def __del__(self):
        try:
            self.thr.join(timeout=1)
            print('join returned, alive =', self.thr.is_alive())
        except PythonFinalizationError:
            print('got the correct exception!')

Cycle()
