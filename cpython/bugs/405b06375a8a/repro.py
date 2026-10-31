import multiprocessing, faulthandler, queue, time
from concurrent import futures
from concurrent.futures import process
from concurrent.futures.process import _ThreadWakeup

faulthandler.dump_traceback_later(20, exit=True)

thread_run = process._ExecutorManagerThread.run
def mock_run(self):
    time.sleep(1)
    thread_run(self)

class MockWakeup(_ThreadWakeup):
    def __init__(self):
        super().__init__()
        self._dummy_queue = queue.Queue(maxsize=1)

    def wakeup(self):
        self._dummy_queue.put(None, block=True)
        super().wakeup()

    def clear(self):
        super().clear()
        try:
            while True:
                self._dummy_queue.get_nowait()
        except queue.Empty:
            pass

def f(x):
    return x

if __name__ == "__main__":
    process._ExecutorManagerThread.run = mock_run
    process._ThreadWakeup = MockWakeup
    with futures.ProcessPoolExecutor(max_workers=2, mp_context=multiprocessing.get_context("spawn")) as ex:
        print(list(ex.map(f, range(10))))
