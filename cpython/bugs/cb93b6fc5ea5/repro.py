import subprocess, sys
code = """if True:
    import sys
    import threading

    threading.x = sys.modules[__name__]
    x = threading._DummyThread()
"""
p = subprocess.run([sys.executable, "-c", code], capture_output=True)
lines = p.stderr.decode().splitlines()
print(p.returncode, p.stdout, lines[-1:] )
