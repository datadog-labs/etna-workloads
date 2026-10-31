import os, sys
os.makedirs("pkg")
def w(p, t):
    with open(p, "w") as f:
        f.write(t)
w("pkg/__init__.py", "")
w("pkg/target.py", "VALUE = 1\n")
w("pkg/runner.py", '''import sys
seen = []
def my_filter(importer, name, fromlist):
    seen.append((importer, name, fromlist))
    return True
sys.set_lazy_imports_filter(my_filter)
lazy from .target import VALUE
lazy from . import target
print(seen)
''')
sys.path.insert(0, os.getcwd())
import pkg.runner
