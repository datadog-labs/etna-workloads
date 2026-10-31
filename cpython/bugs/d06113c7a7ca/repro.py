import _interpreters
import _testcapi

try:
    _testcapi.set_nomemory(0, 1)
    _interpreters.create()
except BaseException as e:
    _testcapi.remove_mem_hooks()
    print(type(e).__name__)
else:
    _testcapi.remove_mem_hooks()
    print("no error")
