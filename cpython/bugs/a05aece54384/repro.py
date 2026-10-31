import subprocess, sys

code = """
import atexit
import _testcapi

def callback():
    print("hello")

atexit.register(callback)
_testcapi.set_nomemory(0)
"""
try:
    p = subprocess.run([sys.executable, "-c", code], capture_output=True, timeout=20)
    print("returncode in (0, 1):", p.returncode in (0, 1))
    print("hello printed:", b"hello" in p.stdout)
except subprocess.TimeoutExpired:
    print("hang during finalization")
