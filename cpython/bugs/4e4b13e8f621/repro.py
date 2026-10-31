import sys, gc

hook = lambda *a: None
sys.addaudithook(hook)

print(any(isinstance(o, list) and any(x is hook for x in o) for o in gc.get_objects()))
