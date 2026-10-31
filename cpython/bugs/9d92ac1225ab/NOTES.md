Runs `python -m profiling.sampling run fail.py` (script is `1/0`) and checks stderr.
Clean: the script's traceback (ZeroDivisionError) is propagated to stderr -> True/True.
Buggy: the coordinator wraps the exception in TargetError / "Unexpected error in profiler
coordinator", so no traceback appears -> False/False.
