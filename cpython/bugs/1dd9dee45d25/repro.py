import os
from concurrent import interpreters

r, w = os.pipe()
interp = interpreters.create()
interp.exec(f"""if True:
    import os, threading, time
    done = False
    def notify_fini():
        global done
        done = True
        os.write({w}, b'F')
        t.join()
    threading._register_atexit(notify_fini)
    def task():
        while not done:
            time.sleep(0.1)
        os.write({w}, b'D')
    t = threading.Thread(target=task)
    t.start()
    os.write({w}, b'I')
""")
try:
    interp.close()
except BaseException as e:
    print(type(e).__name__, e)
for _ in range(3):
    print(os.read(r, 1))
