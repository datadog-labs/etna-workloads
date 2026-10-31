import linecache, inspect, sys, os

open('empty_file.py', 'w').close()
print(repr(linecache.getlines('empty_file.py')))
sys.path.insert(0, os.getcwd())
import empty_file
try:
    print(repr(inspect.getsource(empty_file)))
    print(repr(inspect.getsourcelines(empty_file)))
except OSError as e:
    print('OSError', e)
