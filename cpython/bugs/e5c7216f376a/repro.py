import subprocess, sys

p = subprocess.run([sys.executable, "-q", "-m", "asyncio"], input="print('hi')\n",
                   capture_output=True, text=True, timeout=60)
print(p.returncode)
print(repr(p.stdout))
print(repr(p.stderr))
