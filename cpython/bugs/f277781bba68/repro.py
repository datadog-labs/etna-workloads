import subprocess, sys, os

crasher = """\
import io
import traceback
traceback._print_exception_bltin = None
del io.open
raise RuntimeError("should not crash")
"""
with open("tb_test_no_io_open.py", "w") as f:
    f.write(crasher)
p = subprocess.run([sys.executable, "tb_test_no_io_open.py"],
                   capture_output=True, text=True)
print(p.returncode)
print([l for l in p.stderr.splitlines() if "File" not in l][:3])
