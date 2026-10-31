import subprocess, sys
with open("script.py", "w") as f:
    f.write("nonlocal x\n")
p = subprocess.run([sys.executable, "script.py"], capture_output=True, text=True)
print(p.returncode)
print(p.stderr.splitlines()[-1] if p.stderr else "")
