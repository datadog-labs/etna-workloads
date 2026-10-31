import os, subprocess, sys
os.mkdir("pkg")
open("pkg/__init__.py", "w").close()
with open("pkg/test_x.py", "w") as f:
    f.write("import unittest\nclass T(unittest.TestCase):\n    def test_a(self): pass\n")
for arg in ("pkg/test_x.py", "./pkg/test_x.py"):
    p = subprocess.run([sys.executable, "-m", "unittest", arg], capture_output=True, text=True)
    print(arg, p.returncode)
    print(p.stderr.strip().splitlines()[-1])
