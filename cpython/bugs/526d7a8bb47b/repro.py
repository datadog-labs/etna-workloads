import subprocess, sys

code = "import sys\nsys.stdout.write(sys.stdin.read())\n"
with subprocess.Popen([sys.executable, "-c", code], stdin=subprocess.PIPE,
                      stdout=subprocess.PIPE, text=True) as proc:
    try:
        proc.communicate(input="x" * 200000, timeout=0)
    except subprocess.TimeoutExpired:
        pass
    try:
        out, _ = proc.communicate(timeout=10)
        print("returncode", proc.returncode, "len", len(out))
    except subprocess.TimeoutExpired:
        print("hung: stdin never closed")
        proc.kill()
