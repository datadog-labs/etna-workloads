import logging, logging.handlers, os, threading

os.mkfifo("pipe")
data = None
def other_side():
    global data
    with open("pipe", "rb") as f:
        data = f.read()

t = threading.Thread(target=other_side)
t.start()
rh = logging.handlers.RotatingFileHandler("pipe", encoding="utf-8", maxBytes=1)
rec = logging.makeLogRecord({"msg": "hello"})
try:
    print(rh.shouldRollover(rec))
    rh.emit(rec)
except Exception as e:
    print(type(e).__name__, e)
rh.close()
t.join()
print(repr(data))
