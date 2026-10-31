import sys
sys.modules.pop('stat', None)
sys.modules['_stat'] = None
import stat
print(repr(stat.filemode(0o77777)))
print(repr(stat.filemode(0o177777)))
