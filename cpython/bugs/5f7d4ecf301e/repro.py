import gc, weakref, queue
import multiprocessing.managers as m

class FakeConnection:
    def send(self, payload):
        pass
    def recv(self):
        return '#ERROR', queue.Empty()

gc.disable()
try:
    m.dispatch(FakeConnection(), None, None)
except queue.Empty as e:
    wr = weakref.ref(e)
print(wr() is None)
