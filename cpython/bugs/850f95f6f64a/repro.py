import sys, threading
from unittest.mock import ThreadingMock

m = ThreadingMock()
LOOPS = 2000
THREADS = 10

def work():
    for _ in range(LOOPS):
        m()

sys.setswitchinterval(1e-6)
threads = [threading.Thread(target=work) for _ in range(THREADS)]
for t in threads:
    t.start()
for t in threads:
    t.join()
print(m.call_count == LOOPS * THREADS, len(m.call_args_list))
