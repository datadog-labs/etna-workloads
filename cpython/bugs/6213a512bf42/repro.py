import subprocess, sys
p = subprocess.run([sys.executable, "-q", "-m", "asyncio"], input="",
                   capture_output=True, text=True, env={"TERM": "dumb"})
print(p.returncode)
print(repr(p.stdout))
print('Use "await"' in p.stderr)
