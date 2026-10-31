import os
from multiprocessing import resource_tracker as rt

rt.ensure_running()
r, w = os.pipe()
pid = os.fork()
if pid == 0:
    t = rt._resource_tracker
    os.write(w, b"1" if t._fd is None else b"0")
    os._exit(0)
os.waitpid(pid, 0)
print("raw fork child closed inherited tracker fd:", os.read(r, 1) == b"1")
