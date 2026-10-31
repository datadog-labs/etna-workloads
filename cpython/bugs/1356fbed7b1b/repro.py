from collections import namedtuple
from profiling.sampling.pstats_collector import PstatsCollector

F = namedtuple("F", "filename location funcname opcode")
T = namedtuple("T", "thread_id frame_info status")
I = namedtuple("I", "interpreter_id threads")

c = PstatsCollector(sample_interval_usec=1000)
frames = [F("test.py", (10, 10, 0, 0), "recursive_func", None)] * 5
c.collect([I(0, [T(1, frames, 0)])])
r = c.result[("test.py", 10, "recursive_func")]
print(r["cumulative_calls"], r["direct_calls"])
