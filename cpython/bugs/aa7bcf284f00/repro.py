import os, shutil, signal

def on_alarm(*a):
    raise TimeoutError("blocked")
signal.signal(signal.SIGALRM, on_alarm)

os.mkfifo("pipe")
signal.alarm(2)
try:
    shutil.rmtree("pipe")
except Exception as e:
    print(type(e).__name__)
signal.alarm(0)
print(os.path.exists("pipe"))
