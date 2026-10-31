import os, subprocess, sys, tempfile, time
from _remote_debugging import RemoteUnwinder

name = "zażółć_λάμβδα_𐌀𐌁𐌂𐌃"
script = f"""\
import time
def {name}():
    print("ready", flush=True)
    time.sleep(10_000)
{name}()
"""
with tempfile.TemporaryDirectory() as d:
    path = os.path.join(d, f"mod_{name}.py")
    with open(path, "w", encoding="utf-8") as f:
        f.write(script)
    p = subprocess.Popen([sys.executable, path], stdout=subprocess.PIPE)
    try:
        p.stdout.readline()
        try:
            trace = RemoteUnwinder(p.pid, all_threads=True).get_stack_trace()
            names = [fr.funcname for i in trace for t in i.threads for fr in t.frame_info]
            files = [os.path.basename(fr.filename) for i in trace for t in i.threads for fr in t.frame_info]
            print(name in names, repr(names), repr(files))
        except Exception as e:
            print(type(e).__name__, e)
    finally:
        p.kill(); p.wait(); p.stdout.close()
