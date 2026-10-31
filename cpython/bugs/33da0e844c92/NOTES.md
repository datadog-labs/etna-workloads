repro.py calls _thread._ThreadHandle()._set_done() on an unstarted handle. Clean: RuntimeError 'thread not started'. Buggy (check_started removed): debug assertion failure in set_done, abort (-6).
