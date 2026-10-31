import sys, os, tempfile
events = []
def hook(name, args):
    if "remote" in name:
        events.append(name)
sys.addaudithook(hook)
with tempfile.NamedTemporaryFile("w", suffix=".py", delete=False) as f:
    f.write("pass\n")
try:
    sys.remote_exec(os.getpid(), f.name)
    for i in range(3):
        pass
finally:
    os.unlink(f.name)
print(events)
