import subprocess, sys

code = """
import _testcapi
import weakref

class TestObj:
    pass

def callback(obj):
    pass

obj = TestObj()
wrs = [weakref.ref(obj, callback) for _ in range(50)]
_testcapi.set_nomemory(0)
del obj
"""
res = subprocess.run([sys.executable, "-c", code], capture_output=True)
err = res.stderr.decode("ascii", "backslashreplace")
print("_Py_Dealloc: Deallocator of type 'TestObj'" in err)
