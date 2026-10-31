import subprocess, sys
with open("t.py", "wb") as f:
    f.write('# coding: latin1\nreturn "ä"'.encode('latin1'))
p = subprocess.run([sys.executable, "-I", "t.py"], capture_output=True)
print(p.stderr.decode("utf-8", "replace").splitlines()[-3:])
