import sys, threading, time, types
from importlib import util, abc, machinery

started = threading.Event()
loads = []

class Loader(abc.Loader):
    def create_module(self, spec):
        return None
    def exec_module(self, module):
        loads.append(1)
        started.set()
        time.sleep(0.3)
        module.attr = 42

spec = machinery.ModuleSpec('lazymod', util.LazyLoader(Loader()))
module = util.module_from_spec(spec)
spec.loader.exec_module(module)

def first():
    module.attr

t = threading.Thread(target=first)
t.start()
started.wait()
try:
    print(module.attr)
except Exception as e:
    print(type(e).__name__, e)
t.join()
print(len(loads))
