import subprocess, sys

with subprocess.Popen([sys.executable, "-c", "import sys; sys.exit(0)"],
                      stdin=subprocess.PIPE,
                      stdout=subprocess.PIPE,
                      stderr=subprocess.PIPE) as p:
    p.stdin.close()
    try:
        print(repr(p.communicate()))
    except ValueError as e:
        print("ValueError:", e)
    print(p.returncode)
