import os, subprocess, sys
with open("startup.py", "w") as f:
    f.write("1/0\n")
env = dict(os.environ, PYTHONSTARTUP="startup.py", PYTHON_HISTORY=".hist",
           NO_COLOR="1", TERM="dumb")
env.pop("PYTHON_BASIC_REPL", None)
p = subprocess.run([sys.executable, "-qm", "asyncio"], input="print('user code', 'executed')\n",
                   env=env, capture_output=True, text=True, timeout=60)
print(p.returncode)
for line in (p.stdout + p.stderr).splitlines():
    if "Error" in line or "user code" in line or "startup.py" in line:
        print(line)
