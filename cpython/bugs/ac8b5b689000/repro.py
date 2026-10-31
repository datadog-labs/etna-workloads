import os, sys, threading, time

os.mkdir("pkgdir")
sys.path.insert(0, "pkgdir")
with open("pkgdir/flaky_mod.py", "w") as f:
    f.write("""
import sys
started = sys.modules['sync_state']
started.entered.set()
started.release.wait()
started.runs += 1
if started.runs == 1:
    raise RuntimeError('first attempt fails')
X = 1
""")

class S:
    entered = threading.Event()
    release = threading.Event()
    runs = 0
sys.modules['sync_state'] = S

out = {}
def run(name):
    try:
        import flaky_mod
        out[name] = ('ok', flaky_mod.X if hasattr(flaky_mod, 'X') else 'partial',
                     sys.modules.get('flaky_mod') is flaky_mod)
    except BaseException as e:
        out[name] = (type(e).__name__, str(e))

t1 = threading.Thread(target=run, args=('t1',))
t1.start()
S.entered.wait()
t2 = threading.Thread(target=run, args=('t2',))
t2.start()
time.sleep(0.5)
S.release.set()
t1.join(); t2.join()
print(sorted(out.items()), S.runs)
