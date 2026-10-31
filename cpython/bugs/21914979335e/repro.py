import atexit
import threading
import time

def run():
    print(24)
    time.sleep(1)
    print(42)

@atexit.register
def start_thread():
    threading.Thread(target=run).start()
