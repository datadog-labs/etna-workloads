import subprocess, sys

with open("fail.py", "w") as f:
    f.write("1/0\n")

p = subprocess.run(
    [sys.executable, "-m", "profiling.sampling", "run", "fail.py"],
    capture_output=True, text=True,
)
print("ZeroDivisionError" in p.stderr)
print("Traceback" in p.stderr)
