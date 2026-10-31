import io
from unittest import mock
from profiling.sampling.sample import SampleProfiler

u = mock.MagicMock()
u.get_stack_trace.side_effect = [
    [(1, [mock.MagicMock(filename="test.py", lineno=10, funcname="f")])],
    KeyboardInterrupt(),
]
with mock.patch("_remote_debugging.RemoteUnwinder", return_value=u):
    p = SampleProfiler(pid=12345, sample_interval_usec=10000, all_threads=False)
    with mock.patch("time.perf_counter", side_effect=[0.0, 0.01, 0.02, 0.03, 0.04]):
        out = io.StringIO()
        with mock.patch("sys.stdout", out):
            try:
                p.sample(mock.MagicMock(), duration_sec=1.0)
            except KeyboardInterrupt:
                print("KeyboardInterrupt escaped")
        res = out.getvalue()
print(repr(res))
