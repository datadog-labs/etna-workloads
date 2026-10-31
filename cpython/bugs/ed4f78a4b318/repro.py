import subprocess, sys
src = '''import sys
print(
    "line1"
    "line2"
    file=sys.stderr
)'''
p = subprocess.run([sys.executable, '-c', src], capture_output=True, text=True)
print(p.returncode)
print(p.stderr)
