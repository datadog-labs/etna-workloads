import os, struct, tempfile
from _remote_debugging import InterpreterInfo, ThreadInfo, FrameInfo, LocationInfo
from profiling.sampling.binary_collector import BinaryCollector
from profiling.sampling.binary_reader import BinaryReader

def frame(f, l, n):
    return FrameInfo((f, LocationInfo((l, l, 0, 0)), n, None))

threads = [ThreadInfo((1, 0, [frame("t1.py", 10, "t1")])),
           ThreadInfo((2, 0, [frame("t2.py", 20, "t2")]))]
fd, name = tempfile.mkstemp(suffix=".bin")
os.close(fd)
c = BinaryCollector(name, 1000, compression="none")
c.collect([InterpreterInfo((0, threads))])
c.export(None)
with open(name, "r+b") as raw:
    raw.seek(36)
    raw.write(struct.pack("=I", 1))

class C:
    def collect(self, s, t): pass
    def export(self, f): pass

with BinaryReader(name) as r:
    print(r.get_info()["thread_count"])
    try:
        print(r.replay_samples(C()))
    except ValueError as e:
        print("ValueError:", e)
os.unlink(name)
