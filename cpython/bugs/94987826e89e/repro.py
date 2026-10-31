import sys, types, importlib
sys.modules['spam'] = types.ModuleType('spam')
m = importlib.import_module('spam')
print(m.__spec__)
try:
    importlib.reload(m)
except Exception as e:
    print(type(e).__name__, e)
