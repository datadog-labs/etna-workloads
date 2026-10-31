import subprocess, sys
for t in (-1, 0):
    try:
        subprocess.run([sys.executable, '-c', 'import time;time.sleep(9)'], timeout=t)
    except subprocess.TimeoutExpired as e:
        print(str(e).split("' timed out")[1])
