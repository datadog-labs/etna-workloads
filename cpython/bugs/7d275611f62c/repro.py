import subprocess, sys

with open("script.py", "w") as f:
    f.write("x = 1\nbreakpoint()\n")
p = subprocess.run([sys.executable, "script.py"], input="quit\nn\np x + 1\nquit\ny\n",
                   capture_output=True, text=True, timeout=60)
print(p.returncode)
print(p.stdout.count("Quit anyway"))
print(p.stderr.strip().splitlines()[-1:] )
