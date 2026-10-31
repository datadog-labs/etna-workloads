import os, tempfile
import _remote_debugging as rd

fd, name = tempfile.mkstemp(suffix=".bin")
os.close(fd)
w = rd.BinaryWriter(name, 1000, 0, compression=0)
sample = [rd.InterpreterInfo((0, [rd.ThreadInfo((99, rd.THREAD_STATUS_UNKNOWN, []))]))]
try:
    w.write_sample(sample, 1000)
    w.write_sample(sample, 2000)
    w.finalize()
    print("ok")
except Exception as e:
    print(type(e).__name__, e)
os.unlink(name)
