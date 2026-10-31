import subprocess, sys
proc = subprocess.Popen([sys.executable, '-c',
                         'import os, time; os.close(1); time.sleep(1)'],
                        stdout=subprocess.PIPE)
while True:
    try:
        out = proc.communicate(timeout=0.1)
        print(repr(out))
        break
    except subprocess.TimeoutExpired:
        print("timeout")
        break
    except Exception as e:
        print(type(e).__name__, e)
        break
# second call
try:
    print(repr(proc.communicate(timeout=0.1)))
except subprocess.TimeoutExpired:
    print("timeout2")
except Exception as e:
    print(type(e).__name__, e)
proc.kill(); proc.wait()
