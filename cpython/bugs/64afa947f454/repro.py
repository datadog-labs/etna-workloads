import os, subprocess, sys, tempfile

# sitecustomize runs while site is being imported, i.e. during init.
code = """\
import ctypes
print("Py_IsInitialized during site import:", ctypes.pythonapi.Py_IsInitialized())
"""
with tempfile.TemporaryDirectory() as d:
    with open(os.path.join(d, "sitecustomize.py"), "w") as f:
        f.write(code)
    env = dict(os.environ, PYTHONPATH=d)
    r = subprocess.run([sys.executable, "-c", "pass"], env=env,
                       capture_output=True, text=True)
    print(r.returncode)
    print(r.stdout, end="")
    print(r.stderr, end="")
