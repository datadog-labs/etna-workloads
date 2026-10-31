import os, threading, time, warnings

warnings.simplefilter('error')
t = threading.Thread(target=time.sleep, args=(1,), daemon=True)
t.start()
try:
    pid = os.fork()
except DeprecationWarning as e:
    print("raised DeprecationWarning")
else:
    if pid == 0:
        os._exit(0)
    os.waitpid(pid, 0)
    print("fork succeeded, no exception")
