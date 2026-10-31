import subprocess, sys
try:
    subprocess.run([sys.executable, "-c", "print('will not be run')"], stdout=subprocess.STDOUT)
except Exception as e:
    print(type(e).__name__, e)
