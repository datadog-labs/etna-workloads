import threading
import _testcapi

class C:
    def __del__(self):
        _testcapi.gilstate_ensure_release()

local_var = threading.local()

def callback():
    local_var.x = C()

_testcapi._test_thread_state(callback)
print("done")
