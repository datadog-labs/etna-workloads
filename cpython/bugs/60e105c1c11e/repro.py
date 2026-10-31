import threading
import time

def thread2():
    time.sleep(0.05)
    print("OK")

def thread1():
    time.sleep(0.05)
    t2 = threading.Thread(target=thread2)
    t2.start()

t = threading.Thread(target=thread1)
t.start()
# no join(): interpreter waits for non-daemon threads at shutdown
