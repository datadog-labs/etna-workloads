import os, threading

pid = os.fork()
if pid == 0:
    print(threading.current_thread().native_id == threading.get_native_id(), flush=True)
    os._exit(0)
os.waitpid(pid, 0)
