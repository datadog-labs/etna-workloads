import _queue
q = _queue.SimpleQueue()
a = q.__sizeof__()
for _ in range(1000):
    q.put(None)
print(q.__sizeof__() - a)
