import logging, logging.handlers, os

class H(logging.handlers.RotatingFileHandler):
    def namer(self, name):
        return name + ".test"
    def rotator(self, source, dest):
        if os.path.exists(source):
            os.replace(source, dest + ".rotated")

h = H("log.txt", encoding="utf-8", backupCount=2, maxBytes=1)
print(h.namer("x"))
for i in range(2):
    h.emit(logging.makeLogRecord({"msg": "m%d" % i}))
h.close()
print(sorted(os.listdir(".")))
