import inspect, os, sys

src = '''def decorator(f):
    return f

@decorator
# comment
def func5():
    return 6

@decorator

def func9():
    return 10
'''
with open("fodder_mod.py", "w") as f:
    f.write(src)
sys.path.insert(0, os.getcwd())
import fodder_mod

for fn in (fodder_mod.func5, fodder_mod.func9):
    try:
        lines, start = inspect.getsourcelines(fn)
        print(start, repr("".join(lines)))
    except Exception as e:
        print(type(e).__name__, e)
