import subprocess, sys
p = subprocess.run([sys.executable, "-i", "-u", "-I"], input="def f(x, x): ...\n",
                   capture_output=True, text=True,
                   env={"PYTHON_BASIC_REPL": "1", "TERM": "dumb"})
print(p.stderr.splitlines()[-3:])
