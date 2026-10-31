import inspect, sys, os

with open("mod_fodder.py", "w") as f:
    f.write("def before():\n    pass\n\nclass C:\n    import sys\n    code = sys._getframe(0).f_code\n")
sys.path.insert(0, os.getcwd())
import mod_fodder
print(repr(inspect.getsource(mod_fodder.C.code)))
print(inspect.findsource(mod_fodder.C.code)[1])
